# Methylation analysis of ONT and PacBio long-reads

/// ---------------------------------------- ///

## WORKFLOWS:

* ONT

    * Basecalling with Dorado (optional)
    * Alignment with minimap2
    * Methylation calling with ModKit & DeepMod 2

* PACBIO

    * HiFi reads generation (with --hifi-kinetics option) (optional)
    * CpG methylation prediction using jasmine
    * Alignment with pbmm2
    * Methylation calling with pb-CpG-tools

/// ---------------------------------------- ///

## NOTES:

- DeepMod2 crashes due to some Pysam issues
