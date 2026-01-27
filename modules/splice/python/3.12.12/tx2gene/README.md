# custom_tx2gene

## Description
Make a transcript/gene mapping from a GTF and cross-reference with transcript quantifications.

## Keywords
gene, gtf, pseudoalignment, transcript

## Tool
- **custom**
  - description: "Custom module to create a transcript to gene mapping from a GTF and
check it against transcript quantifications"

  - tool_dev_url: https://github.com/nf-core/modules/blob/master/modules/nf-core/custom/tx2gene/main.nf
  - licence: MIT

## Inputs
- **quant_type**
  - type: string
  - description: Quantification type, 'kallisto' or 'salmon'
- **id**
  - type: string
  - description: Gene ID attribute in the GTF file (default= gene_id)
- **extra**
  - type: string
  - description: Extra gene attribute(s) in the GTF file, comma-separated for multiple (default= gene_name)

## Outputs
- **tx2gene**
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
- repository: https://www.python.org/
- module_source: nf-core/modules
- original_authors: @pinin4fjords

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @pinin4fjords, @HR-cruk
- maintainers: @siddharthjayaraman, @HR-cruk

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
