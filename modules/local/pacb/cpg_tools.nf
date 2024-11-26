process CPG_TOOLS {

  label 'pacb'

  publishDir "${projectDir}/data/methylation/cpg_tools", mode: "copy", pattern: "*.{bed,bw}"

  input:
  tuple val(sample_id), path(aligned_hifi), path(aligned_hifi_index)

  output:
  path "${sample_id}.combined.bed", optional: false, emit: methylation_bed
  path "${sample_id}.combined.bw", optional: false, emit: methylation_bw
  path "${sample_id}.hap1.bed", optional: true, emit: hap1_methylation_bed
  path "${sample_id}.hap1.bw ", optional: true, emit: hap1_methylation_bw
  path "${sample_id}.hap2.bed", optional: true, emit: hap2_methylation_bed
  path "${sample_id}.hap2.bw", optional: true, emit: hap2_methylation_bw

  """
  # Generate site methylation probabilities from mapped HiFi reads
  aligned_bam_to_cpg_scores \
  ${params.cpg_tools_parameters} \
  --bam ${aligned_hifi} \
  --output-prefix ${sample_id} \
  --model ${params.cpg_tools_model_path} \
  --threads \$SLURM_CPUS_ON_NODE
  """

}