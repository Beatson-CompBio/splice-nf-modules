FROM ubuntu:22.04

LABEL org.opencontainers.image.title="bedtools + coreutils"
LABEL org.opencontainers.image.description="bedtools 2.31.1 and coreutils 9.5"

# --------------------------
# System deps
# --------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl bzip2 ca-certificates procps \
    && rm -rf /var/lib/apt/lists/*

# --------------------------
# Install micromamba
# --------------------------
RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest \
    | tar -xvj -C /usr/local/bin --strip-components=1 bin/micromamba

ENV MAMBA_ROOT_PREFIX=/opt/conda
ENV PATH=/opt/conda/bin:/usr/local/bin:$PATH

# --------------------------
# Install packages
# --------------------------
RUN micromamba install -y -n base \
        -c conda-forge -c bioconda \
        bedtools=2.31.1 coreutils=9.5 \
    && micromamba clean -a -y

# --------------------------
# Create a neutral, non-root user
# --------------------------
RUN groupadd -g 1000 nfuser \
 && useradd --create-home --shell /bin/bash -u 1000 -g 1000 nfuser

# --------------------------
# Make common Nextflow paths writable
# --------------------------
RUN mkdir -p /work /home/nfuser \
    && chown -R nfuser:nfuser /work /home/nfuser /opt/conda

USER nfuser
WORKDIR /work

# --------------------------
# Safe default command
# --------------------------
CMD ["bash"]

