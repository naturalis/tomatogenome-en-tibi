#!/bin/bash

#SBATCH --job-name=mapping
#SBATCH --output=mapping_output.txt

# Quality assessment and trimming
fastp \
	-i "/home/rutger.vos/fileserver/projects/B19015-525/En-Tibi_trimmed (paired).R1.fastq.gz" \
	-I "/home/rutger.vos/fileserver/projects/B19015-525/En-Tibi_trimmed (paired).R2.fastq.gz" \
	-o "paired_R1_fastp.fastq.gz" \
	-O "paired_R2_fastp.fastq.gz" \
	-j fastp.json -h fastp.html --verbose

# Assembly
# Indexing the reference
minimap2 \
	-d "Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz.mmi" \
	-t 4 \
	"/home/rutger.vos/fileserver/projects/B19015-525/Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz"

# Mapping
minimap2 \
	-ax sr \
	-a \
	-t 4 \
	"Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz" \
	"paired_R1_fastp.fastq.gz" "paired_R2_fastp.fastq.gz" | samtools view \
	-b -u -F 0x04 --threads 4 -o "paired_En-Tibi.bam" -

# Correct mate pairs
samtools \
	fixmate -r -m  \
	--threads 4 \
	"paired_En-Tibi.bam" \
	"paired_En-Tibi.fixmate.bam"

# Sort the reads
samtools \
  sort -l 0 \
  -m 3G \
  --threads 4 \
  -o "paired_En-Tibi.fixmate.sorted.bam" "paired_En-Tibi.fixmate.bam"

# Mark duplicates
samtools \
  markdup -r \
  --threads 4 \
  "paired_En-Tibi.fixmate.sorted.bam" \
  "paired_En-Tibi.fixmate.sorted.markdup.bam"
