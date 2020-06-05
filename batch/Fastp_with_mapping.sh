#!/bin/bash

#SBATCH --job-name=fastp_mapping
#SBATCH --output=output_fastp_mapping.txt

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

# Assembly
echo "Indexing the reference"
minimap2 \
	-d "../reference/Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz.mmi" \
	-t 4 \
	"../reference/Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz"


echo "Mapping"
minimap2 \
	-ax sr \
	-a \
	-t 4 \
	"../reference/Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz" \
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
