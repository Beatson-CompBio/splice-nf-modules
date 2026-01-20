# Base image
FROM ubuntu:24.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install essential GNU tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    coreutils \
    sed \
    grep \
    gzip \
    tar \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*