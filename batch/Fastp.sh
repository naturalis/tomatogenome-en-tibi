#!/bin/bash

#SBATCH --job-name=fastp
#SBATCH --output=output_fastp.txt

echo "Quality assessment and trimming"
fastp \
        -i "/home/rutger.vos/fileserver/projects/B19015-525/updated/run0220_En-Tibi_S2_L003_R1_001.nophix.fastq.gz" \
        -I "/home/rutger.vos/fileserver/projects/B19015-525/updated/run0220_En-Tibi_S2_L003_R2_001.nophix.fastq.gz" \
        -o "paired_R1_fastp.fastq.gz" \
        -O "paired_R2_fastp.fastq.gz" \
        -j fastp.json -h fastp.html --verbose

