# star_genomegenerate

## Description
Create index for STAR

## Keywords
index, fasta, genome, reference

## Tool
- **star**
  - description: STAR is a software package for mapping DNA sequences against
a large reference genome, such as the human genome.

  - homepage: https://github.com/alexdobin/STAR
  - licence: MIT
  - identifier: biotools:star

## Inputs
_Not specified._

## Outputs
- **index**
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
- repository: https://github.com/alexdobin/STAR
- module_source: nf-core/modules
- original_authors: @kevinmenden, @drpatelh

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @siddhathjayaraman, @kevinmenden, @drpatelh
- maintainers: @siddhathjayaraman, @kevinmenden, @drpatelh

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
