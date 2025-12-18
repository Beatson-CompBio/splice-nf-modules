nextflow.enable.dsl=2

process STAR_GENOMEGENERATE_INDEX {
    tag { meta.id }
    label 'process_high'

    container "quay.io/splice/star_samtools_gawk:2.7.11b_1.21_5.1.0--cfg-f64181b036c1"

    input:
    tuple val(meta), path(fasta)
    tuple val(meta2), path(gtf)
    val   star_genomegenerate_args

    output:
    tuple val(meta), path("star"), emit: index

    script:
    def include_gtf = gtf ? "--sjdbGTFfile ${gtf}" : ''
    def args        = star_genomegenerate_args ?: ''
    """
    mkdir -p star

    STAR \
      --runMode genomeGenerate \
      --genomeDir star/ \
      --genomeFastaFiles ${fasta} \
      ${include_gtf} \
      --runThreadN ${task.cpus} \
      ${args}
    """
}

workflow STAR_GENOMEGENERATE {

    take:
    fasta_ch
    gtf_ch
    star_genomegenerate_args

    main:
    STAR_GENOMEGENERATE_INDEX(fasta_ch, gtf_ch, star_genomegenerate_args)

    emit:
    index = STAR_GENOMEGENERATE_INDEX.out.index
}
