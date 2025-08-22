// MODULE: cruksi/fastqc
// Runs FastQC on a single FASTQ file.

process FASTQC {
  tag { meta?.id ?: reads.baseName }
  cpus 1
  memory '1 GB'
  time '2h'
  conda "${moduleDir}/environment.yml"

  input:
    tuple val(meta), path(reads)

  output:
    tuple val(meta), path("*_fastqc.html"), emit: html
    tuple val(meta), path("*_fastqc.zip"),  emit: zip

  script:
  """
  fastqc --quiet --outdir . ${reads}
  """
}
