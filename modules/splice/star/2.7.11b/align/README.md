# star_align

## Description
Align reads to a reference genome using STAR

## Keywords
align, fasta, genome, reference

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
- **log_final**
- **log_out**
- **log_progress**
- **versions**
- **bam**
- **bam_sorted**
- **bam_sorted_aligned**
- **bam_transcript**
- **bam_unsorted**
- **fastq**
- **tab**
- **spl_junc_tab**
- **read_per_gene_tab**
- **junction**
- **sam**
- **wig**
- **bedgraph**

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
- original_authors: @kevinmenden, @drpatelh, @praveenraj2018

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @siddharthjayaraman, @kevinmenden, @drpatelh, @praveenraj2018
- maintainers: @siddharthjayaraman

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
