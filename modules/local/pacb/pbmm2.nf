process PBMM2 {

  label 'pacb'

  publishDir "${projectDir}/data/aligned", mode: "copy", pattern: "*.pbmm2.log"
  publishDir "${projectDir}/data/aligned", mode: "copy", pattern: "*.aligned.{bam,bam.bai}"

  input:
  each path(ref)
  tuple val(sample_id), path(fivemc_hifi_reads)

  output:
  tuple val("${sample_id}"), path("${sample_id}.aligned.bam"), path("${sample_id}.aligned.bam.bai"), optional: false, emit: aligned_hifi
  path "*.pbmm2.log", optional: false, emit: alignment_reports

  """
  # Align with Minimap2
  pbmm2 align \
  ${params.pbmm2_parameters} \
  --sort \
  --log-level INFO \
  -j \$SLURM_CPUS_ON_NODE \
  ${fivemc_hifi_reads} \
  ${ref} \
  ${sample_id}.aligned.bam 2> ${sample_id}.pbmm2.log
  """

}