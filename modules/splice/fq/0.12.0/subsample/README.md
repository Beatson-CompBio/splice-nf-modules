# fq_subsample

## Description
fq subsample outputs a subset of records from single or paired FASTQ files. This requires a seed (--seed) to be set in ext.args.

## Keywords
fastq, fq, subsample

## Tool
- **fq**
  - description: fq is a library to generate and validate FASTQ file pairs.
  - homepage: https://github.com/stjude-rust-labs/fq
  - documentation: https://github.com/stjude-rust-labs/fq
  - tool_dev_url: https://github.com/stjude-rust-labs/fq
  - licence: MIT

## Inputs
_Not specified._

## Outputs
- **fastq**
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
- repository: https://github.com/stjude-rust-labs/fq
- module_source: nf-core/modules
- original_authors: @adamrtalbot

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @adamrtalbot, @siddharthjayaraman
- maintainers: @siddharthjayaraman

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
