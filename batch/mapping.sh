#!/bin/bash

#SBATCH --job-name=mapping
#SBATCH --output=mapping_output.txt

fastp \
	-i "/home/rutger.vos/fileserver/projects/B19015-525/En-Tibi_trimmed (paired).R1.fastq.gz" \
	-I "/home/rutger.vos/fileserver/projects/B19015-525/En-Tibi_trimmed (paired).R2.fastq.gz" \
	-o "paired_R1_fastp.fastq.gz" \
	-O "paired_R2_fastp.fastq.gz" \
	-j fastp.json -h fastp.html --verbose

minimap2 \
	-d "Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz.mmi" \
	-t 4 \
	"/home/rutger.vos/fileserver/projects/B19015-525/Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz"
minimap2 \
	-ax sr \
	-a \
	-t 4 \
	"Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz.mmi" \
	"paired_R1_fastp.fastq.gz" "paired_R2_fastp.fastq.gz" | samtools view \
	-b -u -F 0x04 --threads 4 -o "run0220_paired_En-Tibi_S2_L003.bam" -
