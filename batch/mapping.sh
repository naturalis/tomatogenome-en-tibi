#!/bin/bash

#SBATCH --job-name=mapping
#SBATCH --output=output_mapping.txt

# Assembly
echo "Indexing the reference"
minimap2 \
	-d "../reference/S_lycopersicum_chromosomes.2.50.fa.gz.mmi" \
	-t 4 \
	"../reference/S_lycopersicum_chromosomes.2.50.fa.gz"

echo "Mapping"
minimap2 \
	-ax sr \
	-a \
	-t 4 \
	"../reference/S_lycopersicum_chromosomes.2.50.fa.gz" \
	"paired_R1_fastp.fastq.gz" "paired_R2_fastp.fastq.gz" | samtools view \
	-b -u -F 0x04 --threads 4 -o "paired_En-Tibi.bam" -

echo "Correct mate pairs"
samtools \
	fixmate -r -m  \
	--threads 4 \
	"paired_En-Tibi.bam" \
	"paired_En-Tibi.fixmate.bam"

echo "Sort the reads"
samtools \
  sort -l 0 \
  -m 3G \
  --threads 4 \
  -o "paired_En-Tibi.fixmate.sorted.bam" "paired_En-Tibi.fixmate.bam"

echo "Mark duplicates"
samtools \
  markdup -r \
  --threads 4 \
  "paired_En-Tibi.fixmate.sorted.bam" \
  "paired_En-Tibi.fixmate.sorted.markdup.bam"
