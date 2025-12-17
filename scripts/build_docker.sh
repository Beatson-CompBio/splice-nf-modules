#!/bin/bash
# build_docker.sh
# Usage:
# ./build_docker.sh [output_dir] "bedtools=2.31.1 coreutils=9.5" "bioconda conda-forge" [quay.io/username/repo]

set -e

# --------------------------
# Arguments
# --------------------------
OUTPUT_DIR="${1:-$(pwd)}"                       # Default output dir is current directory
PACKAGES="${2:-bedtools=2.31.1 coreutils=9.5}"  # Default packages
CHANNELS="${3:-conda-forge bioconda}"           # Default channels
QUAY_REPO="${4:-}"                              # Optional Quay.io repo


# --------------------------
# Convert packages to tag-friendly names
# --------------------------
TOOLS=$(echo $PACKAGES | awk '{for(i=1;i<=NF;i++){split($i,a,"="); printf "%s%s", a[1], (i<NF?"_":"")}}')
VERSIONS=$(echo $PACKAGES | awk '{for(i=1;i<=NF;i++){split($i,a,"="); printf "%s%s", a[2], (i<NF?"_":"")}}')

# --------------------------
# Define base Dockerfile directory
# --------------------------
BASE_DIR="${OUTPUT_DIR}/${TOOLS}_${VERSIONS}"
mkdir -p "$BASE_DIR"

# --------------------------
# Create final Dockerfile directly
# --------------------------
DOCKERFILE_PATH="$BASE_DIR/Dockerfile"
cat > "$DOCKERFILE_PATH" <<EOF
# Base image
FROM ubuntu:22.04

# Metadata
LABEL org.opencontainers.image.title="custom-bio-container"
LABEL org.opencontainers.image.description="Generated Dockerfile for bioinformatics tools"

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \\
        curl bzip2 ca-certificates procps \\
    && rm -rf /var/lib/apt/lists/*

# Install micromamba
RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest \\
    | tar -xvj -C /usr/local/bin --strip-components=1 bin/micromamba

ENV MAMBA_ROOT_PREFIX=/opt/conda
ENV PATH=/opt/conda/bin:/usr/local/bin:\$PATH

# Install packages
ARG PACKAGES="$PACKAGES"
ARG CHANNELS="$CHANNELS"
RUN micromamba install -y -n base \$(echo \$CHANNELS | sed 's/ /\\ -c /g' | sed 's/^/-c /') \$PACKAGES \\
    && micromamba clean -a -y

# Non-root user
ARG NB_UID=1000
ARG NB_GID=1000
RUN groupadd -g \${NB_GID} nfuser \\
 && useradd --create-home --shell /bin/bash -u \${NB_UID} -g \${NB_GID} nfuser

# Work directories
RUN mkdir -p /work /home/nfuser \\
    && chown -R nfuser:nfuser /work /home/nfuser /opt/conda

USER nfuser
WORKDIR /work

CMD ["bash"]
EOF

# --------------------------
# Compute deterministic hash on final Dockerfile
# --------------------------
# Old method using temp file (kept for reference):
# HASH=$(tar --sort=name --mtime='UTC 2025-01-01' --owner=0 --group=0 --numeric-owner -cf - -C "$BASE_DIR" Dockerfile.temp | sha256sum | cut -c1-16)

HASH=$(tar --sort=name \
          --mtime='UTC 2025-01-01' \
          --owner=0 --group=0 --numeric-owner \
          -cf - -C "$BASE_DIR" Dockerfile \
          | sha256sum | cut -c1-16)

echo "Deterministic Dockerfile hash: $HASH"

# --------------------------
# Move Dockerfile into hash directory
# --------------------------
FINAL_DOCKERFILE_DIR="$BASE_DIR/$HASH"
mkdir -p "$FINAL_DOCKERFILE_DIR"
mv "$DOCKERFILE_PATH" "$FINAL_DOCKERFILE_DIR/Dockerfile"

# --------------------------
# Docker image tag
# --------------------------
IMAGE_TAG="${TOOLS}:${VERSIONS}--${HASH}"
echo "Docker image will be: $IMAGE_TAG"

# --------------------------
# Build Docker image
# --------------------------
docker build -t "$IMAGE_TAG" "$FINAL_DOCKERFILE_DIR"

# --------------------------
# Optional: push to Quay.io with automatic login
# --------------------------
if [[ -n "$QUAY_REPO" ]]; then
    # Check if logged in to Quay.io
    if ! docker info 2>/dev/null | grep -q 'Username:'; then
        echo "Not logged in to Docker/Quay.io. Attempting login..."
        docker login quay.io || { echo "Docker login failed. Please login manually with 'docker login quay.io'."; exit 1; }
    fi

    QUAY_IMAGE="$QUAY_REPO/$IMAGE_TAG"
    docker tag "$IMAGE_TAG" "$QUAY_IMAGE"
    echo "Pushing image to Quay.io: $QUAY_IMAGE"
    docker push "$QUAY_IMAGE"
fi

# --------------------------
# Summary
# --------------------------
echo "Done!"
echo "Dockerfile saved at: $FINAL_DOCKERFILE_DIR/Dockerfile"
echo "Docker image: $IMAGE_TAG"
if [[ -n "$QUAY_REPO" ]]; then
    echo "Quay.io image: $QUAY_IMAGE"
fi

