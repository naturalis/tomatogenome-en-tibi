#!/bin/bash

#SBATCH --job-name=SNP_calling
#SBATCH --output=output_SNP_calling.txt

# SNP calling
# Basic stats
#Number of bases with at least 10x coverage:

export MIN_COVERAGE_DEPTH=10
samtools mpileup "paired_En-Tibi.fixmate.sorted.markdup.bam" | awk -v X="${MIN_COVERAGE_DEPTH}" '$4>=X' | wc -l

#Get all the depths (useful for plotting histograms):

samtools depth -a "paired_En-Tibi.fixmate.sorted.markdup.bam" > "paired_En-Tibi.fixmate.sorted.markdup.depth"

#Compute the averages: Run in a separate  batch file due to the use of PERL. This can be done later
#/home/ewout.michels/tomatogenome-en-tibi/batch/Index_high_coverage.sh paired_En-Tibi.fixmate.sorted.markdup.depth

## Index the reference

samtools faidx Solanum_lycopersicum.SL2.50.dna.toplevel.fa

## Do the SNP calling

bcftools mpileup \
  -Ou \
  -f ../reference/Solanum_lycopersicum.SL2.50.dna.toplevel.fa \
  paired_En-Tibi.fixmate.sorted.markdup.bam \
  | bcftools call -Ou -mv \
  | bcftools filter -s LowQual -e '%QUAL<20 || DP>20' \
  > paired_En-Tibi.fixmate.sorted.markdup.flt.vcf

# It is necessary to index the regions of the genome which have 10X coverage for the rest of the pipeline.
# We might need to do this in a separate script since this custom code was written in Perl.
# SNP merging

## Make target list
# has to be done in a separate file due to the use of PERL
#Given paired_En-Tibi.fixmate.sorted.markdup.depth, creates a 2-column TSV (chromo,pos) with sites cover>=10,
#i.e. mincover10.tsv, which is used by bcftools.

#/home/ewout.michels/tomatogenome-en-tibi/batch/Index_high_coverage.sh
