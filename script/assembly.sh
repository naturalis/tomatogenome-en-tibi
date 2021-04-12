#!/bin/bash

# fw reads
IN1=$1

# rev reads
IN2=$2

# cpDNA fasta refseq, indexed with minimap2
# https://github.com/naturalis/tomatogenome-en-tibi/blob/master/doc/Pipeline.md#3-indexing-the-reference
REF=$3

# base name of the output file
BASE=$4

# quality assessment and trimming
fastp \
        -i $IN1 \
    	-I $IN2 \
        -o ${IN1}.qt \
    	-O ${IN2}.qt \
        -j fastp.json -h fastp.html --verbose

# Illumina adaptor trimming: look up adaptors 
# cutadapt \
#    	-a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
#	    -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
#    	-o paired_R1_fastp.fastq.gz \
#       -p paired_R2_fastp.fastq.gz \
#    	untrimmed_paired_R1_fastp.fastq.gz \
#       untrimmed_paired_R2_fastp.fastq.gz

# paired-end mapping assembly
minimap2 -ax sr -a -t 4 $REF \
	${IN1}.qt ${IN2}.qt | samtools view \
	-b -u -F 0x04 --threads 4 -o ${BASE}.bam -

# sort by read name, apparently needed for fixmate: 
# https://www.biostars.org/p/365882/#365887
samtools sort -n -l 0 -m 3G --threads 4 \
	-o ${BASE}.nsort.bam ${BASE}.bam

# correct mate pairs
samtools fixmate -r -m  --threads 4 \
    	${BASE}.nsort.bam ${BASE}.fixmate.bam

# sort numerically
samtools sort -l 0 -m 3G --threads 4 \
	-o ${BASE}.sort.bam ${BASE}.fixmate.bam

# remove duplicates
samtools markdup -r --threads 4 \
	${BASE}.sort.bam" ${BASE}.markdup.bam
	
