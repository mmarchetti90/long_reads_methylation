process MINIMAP2 {

  label 'ont'

  publishDir "${projectDir}/data/aligned", mode: "copy", pattern: "*.minimap2.log"
  publishDir "${projectDir}/data/aligned", mode: "copy", pattern: "*.aligned.{bam,bam.bai}"

  input:
  each path(ref)
  tuple val(sample_id), path(ont_reads)

  output:
  tuple val("${sample_id}"), path("${sample_id}.aligned.bam"), path("${sample_id}.aligned.bam.bai"), optional: false, emit: aligned_ont
  path "*.minimap2.log", optional: false, emit: alignment_reports

  """
  # Convert to fastq preserving tags, then align with Minimap2
  samtools fastq \
  ${ont_reads} \
  -T mv,ts,MM,ML | \
  minimap2 \
  ${params.minimap2_parameters} \
  -t \$SLURM_CPUS_ON_NODE \
  -ax map-ont \
  ${ref} \
  - \
  -y | \
  samtools view \
  -h \
  -o aln.sam

  # Sort and convert to bam
  samtools sort \
  -@ \$SLURM_CPUS_ON_NODE \
  aln.sam \
  -o ${sample_id}.aligned.bam

  # Index
  samtools index \
  -b \
  -@ \$SLURM_CPUS_ON_NODE \
  ${sample_id}.aligned.bam

  # Stats
  samtools flagstat \
  -@ \$SLURM_CPUS_ON_NODE \
  -O 'default' \
  ${sample_id}.aligned.bam > ${sample_id}.minimap2.log
  """

}