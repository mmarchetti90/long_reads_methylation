process JASMINE {

  label 'pacb'

  publishDir "${projectDir}/data/5mc_hifi", mode: "copy", pattern: "*.5mc.hifi.bam"

  input:
  tuple val(sample_id), path(hifi_reads)

  output:
  tuple val("${sample_id}"), path("${sample_id}.5mc.hifi.bam"), optional: false, emit: fivemc_hifi_reads

  """
  # Predict 5-Methylcytosine (5mC) of each CpG site
  jasmine \
  ${params.jasmine_parameters} \
  ${hifi_reads} \
  ${sample_id}.5mc.hifi.bam
  """

}