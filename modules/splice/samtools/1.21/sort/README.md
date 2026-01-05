# samtools_sort

## Description
Sort SAM/BAM/CRAM file

## Keywords
sort, bam, sam, cram

## Tool
- **samtools**
  - description: SAMtools is a set of utilities for interacting with and post-processing
short DNA sequence read alignments in the SAM, BAM and CRAM formats, written by Heng Li.
These files are generated as output by short read aligners like BWA.

  - homepage: http://www.htslib.org/
  - documentation: http://www.htslib.org/doc/samtools.html
  - licence: MIT
  - identifier: biotools:samtools

## Inputs
_Not specified._

## Outputs
- **bam**
- **cram**
- **crai**
- **csi**
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
- repository: http://www.htslib.org/
- module_source: nf-core/modules
- original_authors: @drpatelh, @ewels, @maxulysse

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @siddhathjayaraman, @drpatelh, @ewels, @matthdsm
- maintainers: @siddhathjayaraman, @drpatelh, @ewels, @matthdsm

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
