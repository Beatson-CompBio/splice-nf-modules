# --------------------------
# Option A: Root install
# --------------------------
FROM ubuntu:22.04

LABEL org.opencontainers.image.title="bedtools + coreutils"
LABEL org.opencontainers.image.description="bedtools 2.31.1 and coreutils 9.5"

# --------------------------
# Install dependencies
# --------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl bzip2 ca-certificates procps sudo \
    && rm -rf /var/lib/apt/lists/*

# --------------------------
# Install micromamba as root
# --------------------------
RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest \
    | tar -xvj -C /usr/local/bin --strip-components=1 bin/micromamba

# Ensure micromamba is in PATH
ENV PATH="/usr/local/bin:${PATH}"
ENV MAMBA_ROOT_PREFIX=/opt/conda

# --------------------------
# Install packages as root
# --------------------------
RUN micromamba install -y -n base \
        -c conda-forge -c bioconda \
        bedtools=2.31.1 coreutils=9.5 \
    && micromamba clean -a -y
    
# --------------------------
# Add conda bin to PATH for everyone (including nfuser)
# --------------------------
ENV PATH="/opt/conda/bin:${PATH}"

# --------------------------
# Create non-root user for nf-test
# --------------------------
ARG NB_UID=1000
ARG NB_GID=1000
RUN groupadd -g ${NB_GID} nfuser && useradd -m -u ${NB_UID} -g nfuser nfuser

USER nfuser
WORKDIR /home/nfuser/work

