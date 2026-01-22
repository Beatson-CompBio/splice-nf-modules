# cat_fastq

## Description
Concatenates fastq files

## Keywords
cat, fastq, concatenate

## Tool
- **cat**
  - description: The cat utility reads files sequentially, writing them to the standard output.

  - documentation: https://www.gnu.org/software/coreutils/manual/html_node/cat-invocation.html
  - licence: GPL-3.0-or-later

## Inputs
_Not specified._

## Outputs
- **reads**
- **versions**

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
- module_source: nf-core/modules/cat/fastq
- original_authors: @joseespinosa

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @joseespinosa, @HR-cruk
- maintainers: @siddharthjayaraman, @HR-cruk

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
