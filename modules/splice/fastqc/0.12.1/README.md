# fastqc

## Description
Run FastQC on sequenced reads

## Keywords
quality control, qc, adapters, fastq

## Tool
- **fastqc**
  - description: FastQC gives general quality metrics about your reads.
It provides information about the quality score distribution
across your reads, the per base sequence content (%A/C/G/T).

You get information about adapter contamination and other
overrepresented sequences.

  - homepage: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
  - documentation: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/
  - licence: GPL-2.0-only
  - identifier: biotools:fastqc

## Inputs
_Not specified._

## Outputs
- **html**
- **zip**
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
- repository: https://www.github.com/s-andrews/FastQC
- module_source: nf-core/modules
- original_authors: @drpatelh

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @drpatelh, @HR-cruk
- maintainers: @HR-cruk, @siddharthjayaraman

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
