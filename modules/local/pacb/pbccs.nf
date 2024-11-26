process PBCCS {

  label 'pacb'

  publishDir "${projectDir}/data/hifi", mode: "copy", pattern: "*.hifi.bam"

  input:
  tuple val(sample_id), path(ccs_reads)

  output:
  tuple val("${sample_id}"), path("${sample_id}.hifi.bam"), optional: false, emit: hifi_reads

  """
  # CCS to HiFi, with kinetics
  ccs \
  ${params.ccs_parameters} \
  --hifi-kinetics \
  ${ccs_reads} \
  ${sample_id}.hifi.bam \
  """

}