
// ----------------Workflow---------------- //

include { PBCCS } from '../../modules/local/pacb/pbccs.nf'
include { JASMINE } from '../../modules/local/pacb/jasmine.nf'
include { PBMM2 } from '../../modules/local/pacb/pbmm2.nf'
include { CPG_TOOLS } from '../../modules/local/pacb/cpg_tools.nf'

workflow PACB {

  main:
  
  // LOADING RESOURCES -------------------- //

  // Loading reads list file
  Channel
    .fromPath("${params.sample_table_path}")
    .splitCsv(header: true, sep: '\t')
    .map{ row -> tuple(row.sample, file(row.bam_path)) }
    .set{ input_reads }

  // Load reference fasta
  Channel
    .fromPath("${params.reference_fasta_path}")
    .set{ ref_fasta }

  // Load gtf annotation
  Channel
    .fromPath("${params.gtf_annotation_path}")
    .set{ gtf_annotation }

  // HIFI READS GENERATION ---------------- //

  if (params.skip_pbccs == true) {

    // Input are HiFi reads
    hifi_reads = input_reads

  }
  else {

    // CCS to HiFi
    PBCCS(input_reads)

    hifi_reads = PBCCS.out.hifi_reads

  }

  // JASMINE ------------------------------ //

  JASMINE(hifi_reads)

  // PBMM2 -------------------------------- //

  PBMM2(ref_fasta, JASMINE.out.fivemc_hifi_reads)

  // CPG TOOLS ---------------------------- //

  CPG_TOOLS(PBMM2.out.aligned_hifi)

}