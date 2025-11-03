# splice-nf-modules
![nf-test](https://github.com/Beatson-CompBio/splice-nf-modules/actions/workflows/nf-test.yml/badge.svg)

Shared **SPLICE** modules for Nextflow DSL2 pipelines (CRUK Scotland Institute namespace: `cruksi`).
These modules are designed to be **vendored** into pipelines using `git subtree` so each
pipeline stays self-contained for TRE/offline environments.

## Why a separate modules repo?
- Reuse across many pipelines without Git submodules.
- Review and pin modules independently of any pipeline.
- Keep pipelines reproducible by vendoring a specific commit (SHA) via `git subtree`.

## Quick usage (vendoring with git subtree)

```bash
# In your pipeline repo
git remote add splice-modules https://github.com/REPLACE_ORG/splice-nf-modules.git

# Vendor modules under modules/
git subtree add --prefix modules splice-modules main --squash

# Update later
git fetch splice-modules
git subtree pull --prefix modules splice-modules main --squash
```

## What’s included now?
- `modules/cruksi/fastqc` — run FastQC (0.12.1) on FASTQ files, emitting HTML and ZIP.
- `modules/cruksi/multiqc` — aggregate QC outputs with MultiQC (1.30).
- `modules/cruksi/_template` — a starter scaffold to create more modules.

## Module design conventions
- **Interface**: accept and emit a `meta` map (when meaningful) plus typed paths.
- **Reproducibility**: pin tool versions in `environment.yml` (Bioconda/Conda-Forge).
- **No network at runtime**: do not download data or images; resolve packages ahead of time.
- **No institute secrets**: configs and paths must be user-supplied.
- **Testability**: each module should have `tests/` with `nf-test` specs and tiny fixtures.

See `docs/CONVENTIONS.md` and `docs/ADDING_MODULES.md` for details.
