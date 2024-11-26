
// ----------------Workflow---------------- //

include { DORADO } from '../../modules/local/ont/dorado.nf'
include { MINIMAP2 } from '../../modules/local/ont/minimap2.nf'
include { MODKIT } from '../../modules/local/ont/modkit.nf'
include { DEEPMOD2 } from '../../modules/local/ont/deepmod2.nf'

workflow ONT {

  main:
  
  // LOADING RESOURCES -------------------- //

  // Load reference fasta
  Channel
    .fromPath("${params.reference_fasta_path}")
    .set{ ref_fasta }

  // Load gtf annotation
  Channel
    .fromPath("${params.gtf_annotation_path}")
    .set{ gtf_annotation }

  // BASECALLING -------------------------- //

  if (params.skip_basecalling == true) {

    // Input is already basecalled

    // Loading basecalled bams
    Channel
      .fromPath("${params.sample_table_path}")
      .splitCsv(header: true, sep: '\t')
      .map{ row -> tuple(row.sample, file(row.bam_path)) }
      .set{ basecalled_ont }

    // Loading FAST5/POD5 list file
    Channel
      .fromPath("${params.sample_table_path}")
      .splitCsv(header: true, sep: '\t')
      .map{ row -> tuple(row.sample, file(row.input_path)) }
      .set{ input_dirs }

  }
  else {

    // Loading FAST5/POD5 list file
    Channel
      .fromPath("${params.sample_table_path}")
      .splitCsv(header: true, sep: '\t')
      .map{ row -> tuple(row.sample, file(row.input_path)) }
      .set{ input_dirs }

    // Dorado basecalling
    DORADO(input_dirs)

    basecalled_ont = DORADO.out.basecalled_ont

  }

  // MINIMAP2 ----------------------------- //

  MINIMAP2(ref_fasta, basecalled_ont)

  // MODKIT ------------------------------- //

  MODKIT(MINIMAP2.out.aligned_ont)

  // DEEPMOD2 ----------------------------- //

  MINIMAP2.out.aligned_ont
  .join(input_dirs, by: 0, remainder: false)
  .set{ deepmod2_input }

  DEEPMOD2(ref_fasta, deepmod2_input)

}