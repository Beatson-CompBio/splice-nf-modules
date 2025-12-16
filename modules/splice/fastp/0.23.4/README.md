# fastp

## Description
Perform adapter/quality trimming on sequencing reads

## Keywords
trimming, quality control, fastq

## Tool
- **fastp**
  - description: A tool designed to provide fast all-in-one preprocessing for FastQ files. This tool is developed in C++ with multithreading supported to afford high performance.

  - documentation: https://github.com/OpenGene/fastp
  - licence: MIT
  - identifier: biotools:fastp

## Inputs
_Not specified._

## Outputs
- **reads**
- **json**
- **html**
- **log**
- **reads_fail**
- **reads_merged**
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
- repository: https://www.github.com/OpenGene/fastp
- module_source: nf-core/modules
- original_authors: @drpatelh

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @drpatelh, @HR-cruk
- maintainers: @HR-cruk, @siddharthjayaraman

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
