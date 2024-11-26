#!/bin/bash
#SBATCH --nodes=1
#SBATCH --account=ucgd-rw
#SBATCH --partition=ucgd-rw
#SBATCH -o ont-out-%j
#SBATCH -e ont-err-%j

# Loading modules
module load singularity/4.1.1 jdk/11

# Main files
profile=ont
sample_table_path="example_sample_table_ont-raw.tsv"
skip_basecalling=false
dorado_model="hac,5mCG_5hmCG"

# Running Nextflow
nextflow_executable=/uufs/chpc.utah.edu/common/HIPAA/u1084359/work_dir/nextflow/nextflow

${nextflow_executable} run main.nf \
-profile ${profile} \
--sample_table_path ${sample_table_path} \
--skip_basecalling ${skip_basecalling} \
--dorado_model ${dorado_model}
