process MODKIT {

  label 'ont'

  publishDir "${projectDir}/data/methylation/modkit", mode: "copy", pattern: "*.pileup.log"
  publishDir "${projectDir}/data/methylation/modkit", mode: "copy", pattern: "*.pileup.bed"

  input:
  tuple val(sample_id), path(aligned_ont), path(aligned_ont_index)

  output:
  path "${sample_id}.pileup.bed", optional: false, emit: methylation_bed
  path "${sample_id}.pileup.log", optional: false, emit: modkit_reports

  """
  # Constructing bedMethyl tables
  modkit pileup \
  ${params.modkit_parameters} \
  -t \$SLURM_CPUS_ON_NODE \
  --log-filepath ${sample_id}.pileup.log \
  ${aligned_ont} \
  ${sample_id}.pileup.bed
  """

}