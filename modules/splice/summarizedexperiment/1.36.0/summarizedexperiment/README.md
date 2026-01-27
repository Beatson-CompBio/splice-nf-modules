# summarizedexperiment_summarizedexperiment

## Description
SummarizedExperiment container

## Keywords
gene, transcript, sample, matrix, assay

## Tool
- **summarizedexperiment**
  - description: The SummarizedExperiment container contains one or more assays, each represented by a matrix-like object of numeric or other mode. The rows typically represent genomic ranges of interest and the columns represent samples.
  - homepage: https://bioconductor.org/packages/release/bioc/html/SummarizedExperiment.html
  - documentation: https://bioconductor.org/packages/release/bioc/vignettes/SummarizedExperiment/inst/doc/SummarizedExperiment.html
  - tool_dev_url: https://github.com/Bioconductor/SummarizedExperiment
  - licence: Artistic-2.0
  - identifier: biotools:summarizedexperiment

## Inputs
_Not specified._

## Outputs
- **rds**
- **log**
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
- repository: https://github.com/arq5x/bedtools2
- module_source: nf-core/modules
- original_authors: @pinin4fjords

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @pinin4fjords, @HR-cruk
- maintainers: @HR-cruk, @siddharthjayaraman

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
