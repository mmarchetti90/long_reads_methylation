process DORADO {

  label 'dorado'

  publishDir "${projectDir}/data/basecall", mode: "copy", pattern: "*.basecall.bam"

  input:
  tuple val(sample_id), path(input_dir)

  output:
  tuple val("${sample_id}"), path("${sample_id}.basecall.bam"), optional: false, emit: basecalled_ont

  """
  # Basecalling
  ${params.dorado_executable_path}dorado basecaller \
  ${params.dorado_model} \
  ${input_dir} \
  --emit-moves \
  ${params.dorado_parameters} > ${sample_id}.basecall.bam
  """

}