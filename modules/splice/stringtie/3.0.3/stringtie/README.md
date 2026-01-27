# stringtie_stringtie

## Description
Transcript assembly and quantification for RNA-Se

## Keywords
transcript, assembly, quantification, gtf

## Tool
- **stringtie2**
  - description: Transcript assembly and quantification for RNA-Seq

  - homepage: https://ccb.jhu.edu/software/stringtie/index.shtml
  - documentation: https://ccb.jhu.edu/software/stringtie/index.shtml?t=manual
  - licence: MIT
  - identifier: biotools:stringtie

## Inputs
- **annotation_gtf**
  - type: file
  - description: Annotation gtf file (optional).

## Outputs
- **transcript_gtf**
- **abundance**
- **coverage_gtf**
- **ballgown**
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
- repository: https://github.com/gpertea/stringtie
- module_source: nf-core/modules
- original_authors: @drpatelh

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @drpatelh, @HR-cruk
- maintainers: @HR-cruk, @siddharthjayaraman

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
