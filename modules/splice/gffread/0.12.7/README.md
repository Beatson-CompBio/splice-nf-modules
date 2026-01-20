# gffread

## Description
Validate, filter, convert and perform various other operations on GFF files

## Keywords
gff, conversion, validation

## Tool
- **gffread**
  - description: GFF/GTF utility providing format conversions, region filtering, FASTA sequence extraction and more.
  - homepage: http://ccb.jhu.edu/software/stringtie/gff.shtml#gffread
  - documentation: http://ccb.jhu.edu/software/stringtie/gff.shtml#gffread
  - tool_dev_url: https://github.com/gpertea/gffread
  - licence: MIT
  - identifier: biotools:gffread

## Inputs
_Not specified._

## Outputs
- **gtf**
- **gffread_gff**
- **gffread_fasta**
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
- repository: https://github.com/gpertea/gffread
- module_source: nf-core/modules
- original_authors: @edmundmiller

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @edmundmiller, @HR-cruk
- maintainers: @HR-cruk, @siddharthjayaraman

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
