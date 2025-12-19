# ucsc_bedclip

## Description
Remove lines from bed file that refer to off-chromosome locations.

## Keywords
bed, genomics, ucsc

## Tool
- **ucsc**
  - description: Remove lines from bed file that refer to off-chromosome locations.
  - homepage: http://hgdownload.cse.ucsc.edu/admin/exe/
  - licence: varies; see http://genome.ucsc.edu/license

## Inputs
_Not specified._

## Outputs
- **bedgraph**
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
- repository: https://github.com/ucscGenomeBrowser/kent
- module_source: nf-core/modules
- original_authors: @drpatelh

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @drpatelh, @HR-cruk
- maintainers: @HR-cruk, @siddharthjayaraman

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
