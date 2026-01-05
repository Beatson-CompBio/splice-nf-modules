#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./scripts/build_container.sh --mode <dry-run|local|push> <container_dir> <tool_list>

Examples:
  ./scripts/build_container.sh --mode dry-run containers/splice/star_samtools star,samtools
  ./scripts/build_container.sh --mode local   containers/splice/star_samtools star,samtools
  ./scripts/build_container.sh --mode push    containers/splice/star_samtools star,samtools

Notes:
  - Required files in <container_dir>: Dockerfile, environment.yaml, buildx.args
  - tool_list is a comma separated list of packages to include in the version tag, in that order
  - Tag format: <toolA>-<ver>_<toolB>-<ver>--cfg-<12charhash>
  - local mode appends: -local
  - Config hash is derived from Dockerfile + environment.yaml + buildx.args
EOF
  exit 1
}

MODE=""
ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      shift
      [[ $# -gt 0 ]] || usage
      MODE="$1"
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      ARGS+=( "$1" )
      shift
      ;;
  esac
done

if [[ -z "${MODE}" ]]; then
  echo "ERROR: --mode is required"
  usage
fi

case "${MODE}" in
  dry-run|local|push) ;;
  *)
    echo "ERROR: Invalid mode '${MODE}'"
    usage
    ;;
esac

if [[ "${#ARGS[@]}" -ne 2 ]]; then
  usage
fi

CONTAINER_DIR_INPUT="${ARGS[0]}"
TOOL_LIST_RAW="${ARGS[1]}"

CONTAINER_DIR="$(cd "${CONTAINER_DIR_INPUT}" && pwd)"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

ENV_YML="${CONTAINER_DIR}/environment.yaml"
DOCKERFILE="${CONTAINER_DIR}/Dockerfile"
BUILDX_ARGS_FILE="${CONTAINER_DIR}/buildx.args"
BUILDS_DIR="${CONTAINER_DIR}/builds"

mkdir -p "${BUILDS_DIR}"

if [[ ! -f "${ENV_YML}" || ! -f "${DOCKERFILE}" || ! -f "${BUILDX_ARGS_FILE}" ]]; then
  echo "ERROR: Missing one or more required files in ${CONTAINER_DIR}"
  echo "Expected: Dockerfile, environment.yaml, buildx.args"
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

trim() {
  local s="$1"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf "%s" "$s"
}

extract_version() {
  # Matches:
  #   - bioconda::star=2.7.11b
  #   - star=2.7.11b
  # Avoids pure comment lines by ensuring something non-# exists after the dash.
  local pkg="$1"
  local yml="$2"
  local line

  line="$(grep -E "^[[:space:]]*-[[:space:]]*[^#]*::${pkg}=" "$yml" | head -n 1 || true)"
  if [[ -z "$line" ]]; then
    line="$(grep -E "^[[:space:]]*-[[:space:]]*[^#]*${pkg}=" "$yml" | head -n 1 || true)"
  fi

  if [[ -z "$line" ]]; then
    echo ""
    return 0
  fi

  echo "$line" | sed -E 's/^.*=//'
}

# Reads buildx.args into global array BUILDX_ARGS
read_buildx_args_filtered() {
  local f="$1"
  BUILDX_ARGS=()

  while IFS= read -r line || [[ -n "$line" ]]; do
    line="$(trim "$line")"
    [[ -z "$line" ]] && continue
    [[ "${line:0:1}" == "#" ]] && continue

    # Disallow things controlled by the script
    case "$line" in
      --push|--load|-t|--tag)
        echo "ERROR: buildx.args contains '${line}' which is controlled by the script"
        echo "Remove it from buildx.args"
        exit 1
        ;;
    esac

    BUILDX_ARGS+=( "$line" )
  done < "$f"
}

parse_platforms_from_args() {
  # Returns platform string from args (empty if not found)
  # Handles both:
  #   --platform=linux/amd64
  #   --platform linux/amd64
  local i=0
  local p=""

  while [[ $i -lt ${#BUILDX_ARGS[@]} ]]; do
    case "${BUILDX_ARGS[$i]}" in
      --platform=*)
        p="${BUILDX_ARGS[$i]#--platform=}"
        break
        ;;
      --platform)
        if [[ $((i+1)) -lt ${#BUILDX_ARGS[@]} ]]; then
          p="${BUILDX_ARGS[$((i+1))]}"
          break
        fi
        ;;
    esac
    i=$((i+1))
  done

  printf "%s" "$p"
}

# -------- Identity hash --------

ENV_HASH="$(sha256_of_file "${ENV_YML}")"
DOCKERFILE_HASH="$(sha256_of_file "${DOCKERFILE}")"
BUILDX_ARGS_HASH="$(sha256_of_file "${BUILDX_ARGS_FILE}")"

CFG_HASH_FULL="$(sha256_of_string "${ENV_HASH}${DOCKERFILE_HASH}${BUILDX_ARGS_HASH}")"
CFG_HASH="${CFG_HASH_FULL:0:12}"

# -------- Tool list and tag --------

IFS=',' read -r -a TOOLS <<< "${TOOL_LIST_RAW}"

VERSION_PARTS=()
TOOLS_JSON=()

for t in "${TOOLS[@]}"; do
  t="$(trim "$t")"
  [[ -z "$t" ]] && continue

  v="$(extract_version "$t" "${ENV_YML}")"
  if [[ -z "$v" ]]; then
    echo "ERROR: Could not find version for '${t}' in ${ENV_YML}"
    exit 1
  fi

  VERSION_PARTS+=( "${v}" )
  TOOLS_JSON+=( "\"${t}\": \"${v}\"" )
done

if [[ "${#VERSION_PARTS[@]}" -eq 0 ]]; then
  echo "ERROR: tool_list parsed to an empty list"
  exit 1
fi

VERSION_STR="$(IFS=_; echo "${VERSION_PARTS[*]}")"
TAG_BASE="${VERSION_STR}--cfg-${CFG_HASH}"
TAG="${TAG_BASE}"

if [[ "${MODE}" == "local" ]]; then
  TAG="${TAG_BASE}-local"
fi

# -------- Image name --------

IMAGE_NAME="quay.io/splice/$(basename "${CONTAINER_DIR}")"

# -------- Git metadata --------

GIT_COMMIT="$(git -C "${ROOT_DIR}" rev-parse HEAD 2>/dev/null || echo "unknown")"
GIT_COMMIT_SHORT="$(git -C "${ROOT_DIR}" rev-parse --short HEAD 2>/dev/null || echo "unknown")"
GIT_BRANCH="$(git -C "${ROOT_DIR}" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")"
GIT_DIRTY_COUNT="$(git -C "${ROOT_DIR}" status --porcelain 2>/dev/null | wc -l | tr -d ' ' || echo "unknown")"

# -------- Read buildx args --------

read_buildx_args_filtered "${BUILDX_ARGS_FILE}"
PLATFORMS="$(parse_platforms_from_args)"

if [[ "${MODE}" == "local" ]]; then
  if [[ -z "${PLATFORMS}" ]]; then
    echo "ERROR: local mode requires a platform in buildx.args (example: --platform=linux/amd64)"
    exit 1
  fi
  if [[ "${PLATFORMS}" == *","* ]]; then
    echo "ERROR: local mode supports a single platform only, got '${PLATFORMS}'"
    exit 1
  fi
fi

# -------- Dry run --------

if [[ "${MODE}" == "dry-run" ]]; then
  echo "=== DRY RUN ==="
  echo "container_dir: ${CONTAINER_DIR}"
  echo "image: ${IMAGE_NAME}"
  echo "mode: ${MODE}"
  echo "tag: ${TAG}"
  echo "cfg_hash: ${CFG_HASH}"
  echo "tool_list: ${TOOL_LIST_RAW}"
  echo "versions: ${VERSION_STR}"
  echo "inputs:"
  echo "  environment_yaml_sha256: ${ENV_HASH}"
  echo "  dockerfile_sha256: ${DOCKERFILE_HASH}"
  echo "  buildx_args_sha256: ${BUILDX_ARGS_HASH}"
  echo "buildx.args:"
  for a in "${BUILDX_ARGS[@]}"; do
    echo "  ${a}"
  done
  echo "==============="
  exit 0
fi

# -------- Ensure buildx --------

if ! docker buildx version >/dev/null 2>&1; then
  echo "ERROR: docker buildx not available. Ensure Docker Desktop is running and buildx is enabled."
  exit 1
fi

BUILDER_NAME="splice_builder"
if ! docker buildx inspect "${BUILDER_NAME}" >/dev/null 2>&1; then
  docker buildx create --name "${BUILDER_NAME}" --use >/dev/null
else
  docker buildx use "${BUILDER_NAME}" >/dev/null
fi

# -------- Logs and reports --------

NAME="$(basename "${CONTAINER_DIR}")"
LOG_FILE="${BUILDS_DIR}/${NAME}__${TAG}.build.log"
BUILD_JSON="${BUILDS_DIR}/${NAME}__${TAG}.json"

OUTPUT_FLAG="--push"
if [[ "${MODE}" == "local" ]]; then
  OUTPUT_FLAG="--load"
fi

# Assemble command
BUILD_CMD=( docker buildx build )
for a in "${BUILDX_ARGS[@]}"; do
  BUILD_CMD+=( "$a" )
done
BUILD_CMD+=( "${OUTPUT_FLAG}" )
BUILD_CMD+=( -t "${IMAGE_NAME}:${TAG}" )
BUILD_CMD+=( --label "org.opencontainers.image.source=https://github.com/Beatson-CompBio/splice-nf-modules" )
BUILD_CMD+=( --label "org.opencontainers.image.revision=${GIT_COMMIT}" )
BUILD_CMD+=( --label "org.opencontainers.image.version=${TAG}" )
BUILD_CMD+=( --label "uk.ac.cruksi.splice.cfg_hash=${CFG_HASH}" )
BUILD_CMD+=( "${CONTAINER_DIR}" )

{
  echo "=== splice container build ==="
  echo "date: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo "container_dir: ${CONTAINER_DIR}"
  echo "image: ${IMAGE_NAME}"
  echo "mode: ${MODE}"
  echo "tag: ${TAG}"
  echo "cfg_hash: ${CFG_HASH}"
  echo "tool_list: ${TOOL_LIST_RAW}"
  echo "versions: ${VERSION_STR}"
  echo "platforms: ${PLATFORMS:-unknown}"
  echo "environment_yaml_sha256: ${ENV_HASH}"
  echo "dockerfile_sha256: ${DOCKERFILE_HASH}"
  echo "buildx_args_sha256: ${BUILDX_ARGS_HASH}"
  echo "git_commit: ${GIT_COMMIT}"
  echo "git_branch: ${GIT_BRANCH}"
  echo "git_dirty_count: ${GIT_DIRTY_COUNT}"
  echo "buildx.args:"
  for a in "${BUILDX_ARGS[@]}"; do
    echo "  ${a}"
  done
  echo "command:"
  printf "%q " "${BUILD_CMD[@]}"
  echo
  echo "=============================="
  echo
} > "${LOG_FILE}"

set +e
"${BUILD_CMD[@]}" 2>&1 | tee -a "${LOG_FILE}"
BUILD_EXIT="${PIPESTATUS[0]}"
set -e

if [[ "${BUILD_EXIT}" -ne 0 ]]; then
  echo "ERROR: docker buildx build failed (exit ${BUILD_EXIT})"
  echo "See build log: ${LOG_FILE}"
  exit "${BUILD_EXIT}"
fi

LOG_SHA256="$(sha256_of_file "${LOG_FILE}")"
TOOLS_JSON_JOINED="$(IFS=','; echo "${TOOLS_JSON[*]}")"

cat > "${BUILD_JSON}" <<EOF
{
  "image": "${IMAGE_NAME}",
  "mode": "${MODE}",
  "tag": "${TAG}",
  "tag_base": "${TAG_BASE}",
  "cfg_hash": "${CFG_HASH}",
  "tool_list": "${TOOL_LIST_RAW}",
  "tools": { ${TOOLS_JSON_JOINED} },
  "inputs": {
    "environment_yaml_sha256": "${ENV_HASH}",
    "dockerfile_sha256": "${DOCKERFILE_HASH}",
    "buildx_args_sha256": "${BUILDX_ARGS_HASH}"
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

if [[ "${MODE}" == "local" ]]; then
  echo "✔ Built locally: ${IMAGE_NAME}:${TAG}"
  echo "Next: test locally, then rerun with --mode push using the same inputs"
else
  echo "✔ Built and pushed: ${IMAGE_NAME}:${TAG}"
fi

echo "✔ Build log: ${LOG_FILE}"
echo "✔ Build report: ${BUILD_JSON}"