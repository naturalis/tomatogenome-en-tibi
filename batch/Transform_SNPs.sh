#!/bin/bash

#SBATCH --job-name=Transform
#SBATCH --output=output_transform_SNPs.txt

## Transform to CSV for [snps table](../script/schema.sql)

    perl ../script/gff2csv.pl paired_En-Tibi.fixmate.sorted.markdup.flt.mincover10.vcf \
        | sed -e 's/$/,En-Tibi/' > En-Tibi.csv

## Simplify and transform the 360 snps:

#accessions=$(ls *.vcf.gz | sed -e 's/.vcf.gz//')
#for acc in $accessions; do
#        bcftools view --threads 3 -H -T ../../bam/mincover10.tsv $acc.vcf.gz \
#                | tee $acc.mincover10.vcf \
#                | egrep -v 'DP=\d;' \
#                | perl gff2csv.pl \
#                | sed -e "s/$/,$acc/" > $acc.csv

