# custom_getchromsizes

## Description
Generates a FASTA file of chromosome sizes and a fasta index file

## Keywords
fasta, chromosome, indexing

## Tool
- **samtools**
  - description: Tools for dealing with SAM, BAM and CRAM files
  - homepage: http://www.htslib.org/
  - documentation: http://www.htslib.org/doc/samtools.html
  - tool_dev_url: https://github.com/samtools/samtools
  - licence: MIT

## Inputs
_Not specified._

## Outputs
- **sizes**
- **fai**
- **gzi**
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
- repository: http://www.htslib.org/
- module_source: nf-core/modules
- original_authors: @tamara-hodgetts, @chris-cheshire, @muffato

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @tamara-hodgetts, @chris-cheshire, @muffato, @HR-cruk
- maintainers: @HR-cruk, @siddharthjayaraman

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
