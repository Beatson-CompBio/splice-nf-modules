# multiqc

## Description
Aggregate results from bioinformatics analyses across many samples into a single report

## Keywords
QC, bioinformatics tools, Beautiful stand-alone HTML report

## Tool
- **multiqc**
  - description: MultiQC searches a given directory for analysis logs and compiles a HTML report.
It's a general use tool, perfect for summarising the output from numerous bioinformatics tools.

  - homepage: https://multiqc.info/
  - documentation: https://multiqc.info/docs/
  - licence: GPL-3.0-or-later
  - identifier: biotools:multiqc

## Inputs
- **multiqc_files**
  - type: file
  - description: List of reports / files recognised by MultiQC, for example the html and zip output of FastQC
- **multiqc_config**
  - type: file
  - pattern: *.{yml,yaml}
  - description: Optional config yml for MultiQC
- **extra_multiqc_config**
  - type: file
  - pattern: *.{yml,yaml}
  - description: Second optional config yml for MultiQC. Will override common sections in multiqc_config.
- **multiqc_logo**
  - type: file
  - pattern: *.{png}
  - description: Optional logo file for MultiQC
- **replace_names**
  - type: file
  - pattern: *.{tsv}
  - description: Optional two-column sample renaming file. First column a set of
patterns, second column a set of corresponding replacements. Passed via
MultiQC's `--replace-names` option.
- **sample_names**
  - type: file
  - pattern: *.{tsv}
  - description: Optional TSV file with headers, passed to the MultiQC --sample_names
argument.

## Outputs
- **report**
  - *multiqc_report.html
    - pattern: multiqc_report.html
    - description: MultiQC report file
- **data**
  - *_data
    - pattern: multiqc_data
    - description: MultiQC data dir
- **plots**
  - *_plots
    - pattern: *_data
    - description: Plots created by MultiQC
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
- repository: https://github.com/MultiQC/MultiQC
- module_source: nf-core/modules
- original_authors: @abhi18av

This module was originally developed in the nf-core ecosystem and
has been adapted and versioned for the splice-nf-modules repository.

## Contacts
- authors: @abhi18av, @HR-cruk
- maintainers: @HR-cruk, @siddharthjayaraman

---

This README is generated from `meta.yml`. If you need to update it, edit `meta.yml` and rerun the generator.
