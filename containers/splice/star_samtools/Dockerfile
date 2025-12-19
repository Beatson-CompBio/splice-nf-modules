# ---------- Stage 1: build the conda env ----------
FROM ubuntu:24.04 AS builder

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      bzip2 \
      tar && \
    rm -rf /var/lib/apt/lists/*

ENV MAMBA_ROOT_PREFIX=/opt/micromamba
ENV MAMBA_EXE=/usr/local/bin/micromamba

# Install micromamba (static binary)
RUN curl -Ls "https://micro.mamba.pm/api/micromamba/linux-64/latest" \
  | tar -xvj -C /usr/local/bin --strip-components=1 bin/micromamba && \
  micromamba --version

COPY environment.yaml /tmp/environment.yaml

# Build env at fixed prefix
RUN micromamba create -y -p /opt/conda/envs/star_env -f /tmp/environment.yaml && \
    micromamba run -p /opt/conda/envs/star_env which STAR samtools gawk && \
    micromamba clean --all --yes && \
    rm -f /tmp/environment.yaml


# ---------- Stage 2: runtime ----------
FROM ubuntu:24.04

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Nextflow expects ps for task metrics
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      procps \
      bash && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/conda/envs/star_env /opt/conda/envs/star_env

ENV PATH=/opt/conda/envs/star_env/bin:$PATH
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Do not set USER here.
# Nextflow / Docker will run as whatever UID it chooses (often the host UID),
# avoiding permission surprises in work dirs.

CMD ["bash"]
