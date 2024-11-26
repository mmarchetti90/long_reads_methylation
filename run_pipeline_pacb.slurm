#!/bin/bash
#SBATCH --nodes=1
#SBATCH --account=ucgd-rw
#SBATCH --partition=ucgd-rw
#SBATCH -o pacb-out-%j
#SBATCH -e pacb-err-%j

# Loading modules
module load singularity/4.1.1 jdk/11

# Main files
profile=pacb
sample_table_path="example_sample_table_pacb.tsv"
skip_pbccs=false

# Running Nextflow
nextflow_executable=/uufs/chpc.utah.edu/common/HIPAA/u1084359/work_dir/nextflow/nextflow

${nextflow_executable} run main.nf \
-profile ${profile} \
--sample_table_path ${sample_table_path} \
--skip_pbccs ${skip_pbccs}
