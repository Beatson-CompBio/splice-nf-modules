# untar

## Description
Extract files from tar, tar.gz, tar.bz2, tar.xz archives

## Keywords
untar, uncompress, extract

## Tool
- **untar**
  - description: Extract tar, tar.gz, tar.bz2, tar.xz files.

  - documentation: https://www.gnu.org/software/tar/manual/
  - licence: GPL-3.0-or-later

## Inputs
_Not specified._

## Outputs
- **untar**
- **versions**
  - versions.yml
    - pattern: versions.yml
    - description: File containing software versions

## Usage
This directory contains a Nextflow module.

- Module script: `main.nf`
- Metadata: `meta.yml`
- Tests: `tests/`

Import and call the module from a Nextflow workflow using your usual module include pattern.

## Task extensions
This module may support per invocation options via `task.ext.*`.

If you extend this module, document new `task.ext.*` keys here in the README.

## Provenance
- repository: https://github.com/coreutils/coreutils
- module_source: nf-core/modules/untar
- original_authors: @joseespinosa, @drpatelh, @matthdsm, @jfy133

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @joseespinosa, @drpatelh, @matthdsm, @jfy133, HR-cruk
- maintainers: @HR-cruk, @siddharthjayaraman

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
