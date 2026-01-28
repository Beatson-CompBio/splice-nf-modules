# subread_featurecounts

## Description
Count reads that map to genomic features

## Keywords
counts, fasta, genome, reference

## Tool
- **featurecounts**
  - description: featureCounts is a highly efficient general-purpose read summarization program that counts mapped reads for genomic features such as genes, exons, promoter, gene bodies, genomic bins and chromosomal locations. It can be used to count both RNA-seq and genomic DNA-seq reads.
  - homepage: http://bioinf.wehi.edu.au/featureCounts/
  - documentation: http://bioinf.wehi.edu.au/subread-package/SubreadUsersGuide.pdf
  - licence: GPL v3
  - identifier: biotools:subread

## Inputs
_Not specified._

## Outputs
- **counts**
- **summary**
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
- repository: https://subread.sourceforge.net/
- module_source: nf-core/modules
- original_authors: @ntoda03

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @ntoda03, @HR-cruk
- maintainers: @HR-cruk, @siddharthjayaraman

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
