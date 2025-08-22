// MODULE: cruksi/multiqc
// Aggregates QC outputs present in the working directory (staged by Nextflow).
// Provide one or more input files/dirs to stage them, then MultiQC scans '.'

process MULTIQC {
  tag { 'multiqc' }
  cpus 1
  memory '1 GB'
  time '2h'
  conda "${moduleDir}/environment.yml"

  input:
    path(qc_items)

  output:
    path "*multiqc_report.html", emit: report
    path "multiqc_data",        emit: data

  script:
  """
  multiqc --force --outdir . .
  """
}
