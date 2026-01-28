# bedtools_genomecov

## Description
Computes histograms (default), per-base reports (-d) and BEDGRAPH (-bg) summaries of feature coverage (e.g., aligned sequences) for a given genome.

## Keywords
bed, bam, genomecov, bedtools, histogram

## Tool
- **bedtools**
  - description: A set of tools for genomic analysis tasks, specifically enabling genome arithmetic (merge, count, complement) on various file types.

  - documentation: https://bedtools.readthedocs.io/en/latest/content/tools/genomecov.html
  - licence: MIT
  - identifier: biotools:bedtools

## Inputs
_Not specified._

## Outputs
- **genomecov**
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
- repository: https://github.com/arq5x/bedtools2
- module_source: nf-core/modules
- original_authors: @edmundmiller, @sruthipsuresh, @drpatelh, @sidorov-si, @chris-cheshire

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @edmundmiller, @sruthipsuresh, @drpatelh, @sidorov-si, @chris-cheshire, @HR-cruk
- maintainers: @HR-cruk, @siddharthjayaraman

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
