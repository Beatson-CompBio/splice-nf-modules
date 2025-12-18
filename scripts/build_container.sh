#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <container_directory>"
  exit 1
fi

CONTAINER_DIR="$(cd "$1" && pwd)"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ENV_YML="${CONTAINER_DIR}/env.yml"
DOCKERFILE="${CONTAINER_DIR}/Dockerfile"
BUILDS_DIR="${CONTAINER_DIR}/builds"

mkdir -p "${BUILDS_DIR}"

if [[ ! -f "${ENV_YML}" || ! -f "${DOCKERFILE}" ]]; then
  echo "ERROR: env.yml or Dockerfile not found in ${CONTAINER_DIR}"
  exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: docker not found on PATH"
  exit 1
fi

# -------- Helpers --------

sha256_of_file() {
  local f="$1"
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$f" | awk '{print $1}'
  else
    shasum -a 256 "$f" | awk '{print $1}'
  fi
}

sha256_of_string() {
  if command -v sha256sum >/dev/null 2>&1; then
    printf "%s" "$1" | sha256sum | awk '{print $1}'
  else
    printf "%s" "$1" | shasum -a 256 | awk '{print $1}'
  fi
}

extract_version() {
  # Extracts the rightmost "=<ver>" on a line like "  - bioconda::star=2.7.11b"
  # Usage: extract_version "star" "/path/to/env.yml"
  local pkg="$1"
  local yml="$2"
  local line
  line="$(grep -E "^[[:space:]]*-[[:space:]]*.*::${pkg}=" "$yml" | head -n 1 || true)"
  if [[ -z "$line" ]]; then
    # fallback: allow non-channel-qualified entries like "- star=2.7.11b"
    line="$(grep -E "^[[:space:]]*-[[:space:]]*${pkg}=" "$yml" | head -n 1 || true)"
  fi
  if [[ -z "$line" ]]; then
    echo ""
    return 0
  fi
  echo "$line" | sed -E 's/^.*=//'
}

# -------- Identity hash (cfg hash) --------

ENV_HASH="$(sha256_of_file "${ENV_YML}")"
DOCKERFILE_HASH="$(sha256_of_file "${DOCKERFILE}")"
CFG_HASH_FULL="$(sha256_of_string "${ENV_HASH}${DOCKERFILE_HASH}")"
CFG_HASH="${CFG_HASH_FULL:0:12}"

# -------- Versions for tag naming --------
# This script is still generic, but it expects env.yml to include these
# because your naming scheme for this container explicitly uses them.

STAR_VERSION="$(extract_version "star" "${ENV_YML}")"
SAMTOOLS_VERSION="$(extract_version "samtools" "${ENV_YML}")"
GAWK_VERSION="$(extract_version "gawk" "${ENV_YML}")"

if [[ -z "${STAR_VERSION}" || -z "${SAMTOOLS_VERSION}" || -z "${GAWK_VERSION}" ]]; then
  echo "ERROR: Could not parse one or more required versions from env.yml"
  echo "Expected to find star=..., samtools=..., gawk=..."
  exit 1
fi

TAG="${STAR_VERSION}_${SAMTOOLS_VERSION}_${GAWK_VERSION}--cfg-${CFG_HASH}"

# -------- Image name --------

IMAGE_NAME="quay.io/splice/$(basename "${CONTAINER_DIR}")"

# -------- Git audit metadata (report only) --------

GIT_COMMIT="$(git -C "${ROOT_DIR}" rev-parse HEAD 2>/dev/null || echo "unknown")"
GIT_COMMIT_SHORT="$(git -C "${ROOT_DIR}" rev-parse --short HEAD 2>/dev/null || echo "unknown")"
GIT_BRANCH="$(git -C "${ROOT_DIR}" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")"
GIT_DIRTY_COUNT="$(git -C "${ROOT_DIR}" status --porcelain 2>/dev/null | wc -l | tr -d ' ' || echo "unknown")"

# -------- Build log path --------

NAME="$(basename "${CONTAINER_DIR}")"
LOG_FILE="${BUILDS_DIR}/${NAME}__${TAG}.build.log"
BUILD_JSON="${BUILDS_DIR}/${NAME}__${TAG}.json"

# -------- Ensure buildx available --------

if ! docker buildx version >/dev/null 2>&1; then
  echo "ERROR: docker buildx not available. Ensure Docker Desktop is running and buildx is installed/enabled."
  exit 1
fi

# Use a stable builder name. Create it if missing.
BUILDER_NAME="splice_builder"
if ! docker buildx inspect "${BUILDER_NAME}" >/dev/null 2>&1; then
  docker buildx create --name "${BUILDER_NAME}" --use >/dev/null
else
  docker buildx use "${BUILDER_NAME}" >/dev/null
fi

# -------- Build + push (capture logs) --------

{
  echo "=== splice container build ==="
  echo "date: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo "container_dir: ${CONTAINER_DIR}"
  echo "image: ${IMAGE_NAME}"
  echo "tag: ${TAG}"
  echo "platform: linux/amd64"
  echo "cfg_hash: ${CFG_HASH}"
  echo "env_yml_sha256: ${ENV_HASH}"
  echo "dockerfile_sha256: ${DOCKERFILE_HASH}"
  echo "git_commit: ${GIT_COMMIT}"
  echo "git_branch: ${GIT_BRANCH}"
  echo "git_dirty_count: ${GIT_DIRTY_COUNT}"
  echo "=============================="
  echo
} > "${LOG_FILE}"

# Build command output appended to log
set +e
docker buildx build \
  --platform linux/amd64 \
  --push \
  -t "${IMAGE_NAME}:${TAG}" \
  --label org.opencontainers.image.source="https://github.com/Beatson-CompBio/splice-nf-modules" \
  --label org.opencontainers.image.revision="${GIT_COMMIT}" \
  --label org.opencontainers.image.version="${TAG}" \
  --label uk.ac.cruksi.splice.cfg_hash="${CFG_HASH}" \
  "${CONTAINER_DIR}" 2>&1 | tee -a "${LOG_FILE}"

BUILD_EXIT="${PIPESTATUS[0]}"
set -e

if [[ "${BUILD_EXIT}" -ne 0 ]]; then
  echo "ERROR: docker buildx build failed (exit ${BUILD_EXIT})"
  echo "See build log: ${LOG_FILE}"
  exit "${BUILD_EXIT}"
fi

LOG_SHA256="$(sha256_of_file "${LOG_FILE}")"

# -------- Write report JSON --------

cat > "${BUILD_JSON}" <<EOF
{
  "image": "${IMAGE_NAME}",
  "tag": "${TAG}",
  "platform": "linux/amd64",
  "cfg_hash": "${CFG_HASH}",
  "tools": {
    "star": "${STAR_VERSION}",
    "samtools": "${SAMTOOLS_VERSION}",
    "gawk": "${GAWK_VERSION}"
  },
  "inputs": {
    "env_yml_sha256": "${ENV_HASH}",
    "dockerfile_sha256": "${DOCKERFILE_HASH}"
  },
  "build_log": {
    "path": "builds/${NAME}__${TAG}.build.log",
    "sha256": "${LOG_SHA256}"
  },
  "git": {
    "commit": "${GIT_COMMIT}",
    "commit_short": "${GIT_COMMIT_SHORT}",
    "branch": "${GIT_BRANCH}",
    "dirty_count": ${GIT_DIRTY_COUNT}
  }
}
EOF

echo "✔ Built and pushed ${IMAGE_NAME}:${TAG}"
echo "✔ Build log: ${LOG_FILE}"
echo "✔ Build report: ${BUILD_JSON}"
