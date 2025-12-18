# STAR + samtools + gawk container

This directory defines a lightweight, reproducible OCI container providing the exact toolchain required by the STAR genome generation and alignment modules in `splice-nf-modules`.

The container is designed to be a **drop-in replacement** for Biocontainers images and is compatible with:

- Docker
- Podman
- Apptainer / Singularity (via OCI → SIF conversion)
- Nextflow container caching and offline use (e.g. S3-backed caches)

No module code or Nextflow configuration changes are required to use this image.

---

## Tools included

| Tool     | Version | Source channel |
| -------- | ------- | -------------- |
| STAR     | 2.7.11b | bioconda       |
| samtools | 1.21    | bioconda       |
| gawk     | 5.1.0   | conda-forge    |

The exact versions are defined in `env.yml` and are reflected in the image tag.

---

## Image naming and tags

Images are published to:

```
quay.io/splice/star_samtools_gawk
```

Tags follow this convention:

```
<star>_<samtools>_<gawk>--cfg-<cfgHash>
```

Example:

```
2.7.11b_1.21_5.1.0--cfg-a94f2c1d3e2f
```

### What the tag means

- `2.7.11b_1.21_5.1.0`
  - Runtime versions of STAR, samtools, and gawk
- `cfg-a94f2c1d3e2f`
  - A deterministic hash derived **only** from:
    - `env.yml`
    - `Dockerfile`

If either file changes, the cfg hash changes, forcing a new image tag. This guarantees full provenance and reproducibility.

---

## Provenance and audit trail

Every build produces two tracked artefacts in `builds/`:

```
builds/
  star_samtools_gawk__<tag>.build.log
  star_samtools_gawk__<tag>.json
```

### Build log (`.build.log`)

- Full stdout and stderr from `docker buildx build`
- Captures solver output, downloads, and build metadata

### Build report (`.json`)

Includes:

- Image name and tag
- Tool versions
- SHA256 of `env.yml` and `Dockerfile`
- SHA256 of the build log
- Git commit, branch, and dirty state at build time

This provides a complete, auditable record linking **source → build → image → pipeline execution**.

---

## How to build the container

From the repository root:

```
./scripts/build_container.sh containers/splice/star_samtools_gawk
```

Requirements:

- Docker (Docker Desktop on macOS or Windows, or Docker Engine on Linux)
- `docker buildx` enabled
- Logged in to Quay:

```
docker login quay.io
```

The build targets `linux/amd64` to ensure compatibility with HPC systems and Apptainer.

---

## Use in Nextflow modules

Modules should reference the image directly, for example:

```
container "quay.io/splice/star_samtools_gawk:2.7.11b_1.21_5.1.0--cfg-a94f2c1d3e2f"
```

For Singularity or Apptainer, Nextflow will automatically:

- pull the OCI image
- convert it to a `.sif`
- cache it using the canonical filename

This allows offline reuse by copying cached images, for example to S3-backed caches.

---

## Why this container exists

Biocontainers mulled images combine multiple tools implicitly and can:

- change composition across rebuilds
- hide exact dependency resolution
- be difficult to audit or reproduce

This container:

- makes all dependencies explicit
- pins versions deterministically
- integrates cleanly with Nextflow caching semantics
- provides long-term provenance suitable for shared or regulated platforms

---

## Updating or extending the container

1. Edit `env.yml` to add or change tools
2. Update the README table if needed
3. Rebuild using the build script
4. Commit the new build artefacts under `builds/`

Never reuse an existing tag for a modified `env.yml` or `Dockerfile`.

---

## Conventions

This container follows the shared SPLICE container conventions:

- Single cfg hash derived from inputs
- Versioned, immutable tags
- No container-specific logic in build scripts
- All provenance stored in-repo

See `docs/CONTAINER_CONVENTIONS.md` for cross-container guidelines.

