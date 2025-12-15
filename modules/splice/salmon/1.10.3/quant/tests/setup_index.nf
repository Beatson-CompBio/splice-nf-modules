nextflow.enable.dsl=2

process MAKE_SALMON_INDEX {
    tag "make_index"
    label 'process_single'

    container "${ workflow.containerEngine in ['singularity','apptainer'] && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/salmon:1.10.3--h6dccd9a_2' :
        'quay.io/biocontainers/salmon:1.10.3--h6dccd9a_2' }"

    input:
    path transcriptome_fasta

    output:
    path "salmon_index", emit: index_dir

    script:
    """
    mkdir -p salmon_index

    salmon index \
      -t ${transcriptome_fasta} \
      -i salmon_index
    """
}

workflow SETUP_SALMON_INDEX {
    take:
    transcriptome_fasta

    main:
    MAKE_SALMON_INDEX(transcriptome_fasta)

    emit:
    index_dir = MAKE_SALMON_INDEX.out.index_dir
}