# salmon_quant

## Description
gene/transcript quantification with Salmon

## Keywords
index, fasta, genome, reference

## Tool
- **salmon**
  - description: Salmon is a tool for wicked-fast transcript quantification from RNA-seq data

  - homepage: https://salmon.readthedocs.io/en/latest/salmon.html
  - licence: GPL-3.0-or-later
  - identifier: biotools:salmon

## Inputs
_Not specified._

## Outputs
- **results**
- **json_info**
- **lib_format_counts**
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
- repository: https://github.com/COMBINE-lab/salmon
- module_source: nf-core/modules
- original_authors: @kevinmenden, @drpatelh

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @kevinmenden, @drpatelh, @siddharthjayaraman
- maintainers: @siddharthjayaraman

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
