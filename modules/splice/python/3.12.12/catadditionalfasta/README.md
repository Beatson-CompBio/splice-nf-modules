# custom_catadditionalfasta

## Description
Custom module to Add a new fasta file to an old one and update an associated GTF

## Keywords
fasta, gtf, genomics

## Tool
- **custom**
  - description: Custom module to Add a new fasta file to an old one and update an associated GTF
  - tool_dev_url: https://github.com/nf-core/modules/blob/master/modules/nf-core/custom/catadditionalfasta/main.nf
  - licence: MIT

## Inputs
- **biotype**
  - type: string
  - description: Biotype to apply to new GTF entries

## Outputs
- **fasta**
- **gtf**
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
- repository: https://www.python.org/
- module_source: nf-core/modules
- original_authors: @pinin4fjords

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @pinin4fjords, @HR-cruk
- maintainers: @HR-cruk, @siddharthjayaraman

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
