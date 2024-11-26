process DEEPMOD2 {

  label 'ont'

  publishDir "${projectDir}/data/methylation/deepmod2", mode: "copy", pattern: "*.args"
  publishDir "${projectDir}/data/methylation/deepmod2", mode: "copy", pattern: "*.{bam,per_read,per_site,aggregated}"

  input:
  each path(ref)
  tuple val(sample_id), path(aligned_ont), path(aligned_ont_index), path(input_dir)

  output:
  tuple val("${sample_id}"), path("output.bam"), optional: false, emit: methylation_tagged_bam
  tuple val("${sample_id}"), path("output.per_read"), optional: false, emit: deepmod_per_read
  tuple val("${sample_id}"), path("output.per_site"), optional: false, emit: deepmod_per_site
  tuple val("${sample_id}"), path("output.per_site.aggregated"), optional: false, emit: deepmod_per_site_aggregated
  path "args", optional: false, emit: deepmod_args

  """
  # Detecting DNA 5mC methylation
  python /opt/DeepMod2/deepmod2 detect \
  --bam ${aligned_ont} \
  --input ${input_dir} \
  --model ${params.deepmod2_model} \
  --file_type ${params.input_file_type} \
  --seq_type dna \
  --threads \$SLURM_CPUS_ON_NODE \
  --ref ${ref}

  # Rename outputs to include sample_id
  mv args ${sample_id}.args
  mv output.bam ${sample_id}.bam
  mv output.per_read ${sample_id}.per_read
  mv output.per_site ${sample_id}.per_site
  mv output.per_site.aggregated ${sample_id}.per_site.aggregated
  """

}