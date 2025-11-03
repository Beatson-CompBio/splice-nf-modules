# Modules index
![nf-test](https://github.com/Beatson-CompBio/splice-nf-modules/actions/workflows/nf-test.yml/badge.svg)

This page lists available modules. Paths are relative to the repo root.

| Namespace | Tool | Task | Path |
|---|---|---|---|
| cruksi | fastqc | — | `modules/cruksi/fastqc` |
| cruksi | multiqc | — | `modules/cruksi/multiqc` |
| splice | bedtools | genomecov | `modules/splice/bedtools/genomecov` |
| splice | custom | catadditionalfasta | `modules/splice/custom/catadditionalfasta` |
| splice | custom | getchromsizes | `modules/splice/custom/getchromsizes` |
| splice | custom | tx2gene | `modules/splice/custom/tx2gene` |
| splice | fastp | — | `modules/splice/fastp` |
| splice | fastqc | — | `modules/splice/fastqc` |
| splice | gffread | — | `modules/splice/gffread` |
| splice | multiqc | — | `modules/splice/multiqc` |
| splice | picard | markduplicates | `modules/splice/picard/markduplicates` |
| splice | salmon | index | `modules/splice/salmon/index` |
| splice | salmon | quant | `modules/splice/salmon/quant` |
| splice | samtools | flagstat | `modules/splice/samtools/flagstat` |
| splice | samtools | idxstats | `modules/splice/samtools/idxstats` |
| splice | samtools | index | `modules/splice/samtools/index` |
| splice | samtools | sort | `modules/splice/samtools/sort` |
| splice | samtools | stats | `modules/splice/samtools/stats` |
| splice | star | align | `modules/splice/star/align` |
| splice | star | genomegenerate | `modules/splice/star/genomegenerate` |
| splice | summarizedexperiment | summarizedexperiment | `modules/splice/summarizedexperiment/summarizedexperiment` |
| splice | tximeta | tximport | `modules/splice/tximeta/tximport` |
| splice | ucsc | bedclip | `modules/splice/ucsc/bedclip` |
| splice | ucsc | bedgraphtobigwig | `modules/splice/ucsc/bedgraphtobigwig` |

*Tip:* Each module folder contains `meta.yml`, `environment.yml`, `main.nf`, and `tests/`.
