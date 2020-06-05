#!/bin/bash

#SBATCH --job-name=fastp
#SBATCH --output=output_fastp.txt

echo "Quality assessment and trimming"
fastp \
        -i "/fileserver/projects/B19015-525/updated/run0220_En-Tibi_S2_L003_R1_001.nophix.fastq.gz" \
        -I "/fileserver/projects/B19015-525/updated/run0220_En-Tibi_S2_L003_R2_001.nophix.fastq.gz" \
        -o "untrimmed_paired_R1_fastp.fastq.gz" \
        -O "untrimmed_paired_R2_fastp.fastq.gz" \
        -j fastp.json -h fastp.html --verbose

echo "Cutadapt"

cutadapt \
        -a ADAPTER_FWD -A ADAPTER_REV \
        -o paired_R1_fastp.fastq.gz \
        -p paired_R2_fastp.fastq.gz \
        untrimmed_paired_R1_fastp.fastq.gz \
        untrimmed_paired_R2_fastp.fastq.gz