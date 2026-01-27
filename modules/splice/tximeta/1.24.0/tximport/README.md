# tximeta_tximport

## Description
Import transcript-level abundances and estimated counts for gene-level
analysis packages

## Keywords
gene, kallisto, pseudoalignment, salmon, transcript

## Tool
- **tximeta**
  - description: Transcript Quantification Import with Automatic Metadata
  - homepage: https://bioconductor.org/packages/release/bioc/html/tximeta.html
  - documentation: https://bioconductor.org/packages/release/bioc/vignettes/tximeta/inst/doc/tximeta.html
  - tool_dev_url: https://github.com/thelovelab/tximeta
  - licence: GPL-2
  - identifier: biotools:tximeta

## Inputs
- **quant_type**
  - type: string
  - description: Quantification type, `kallisto` or `salmon`

## Outputs
- **tpm_gene**
- **counts_gene**
- **counts_gene_length_scaled**
- **counts_gene_scaled**
- **lengths_gene**
- **tpm_transcript**
- **counts_transcript**
- **lengths_transcript**
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
- repository: https://github.com/thelovelab/tximeta
- module_source: nf-core/modules
- original_authors: @pinin4fjords

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @pinin4fjords, @HR-cruk
- maintainers: @HR-cruk, @siddharthjayaraman

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
