#!/usr/bin/bash

#SBATCH --job-name=simplify
#SBATCH --output=output_simplify.txt


## Simplify the En Tibi snps:

    bcftools view --threads 3 -H -T mincover10_int_chromo.tsv paired_En-Tibi.fixmate.sorted.markdup.flt.vcf.gz \
        | grep -v LowQual \
        | egrep -v 'DP=\d;' \
        | grep -v INDEL > paired_En-Tibi.fixmate.sorted.markdup.flt.mincover10.vcf

## Transform to CSV for [snps table](../script/schema.sql)

    perl ../360/accessions/gff2csv.pl paired_En-Tibi_S2.fixmate.sorted.markdup.flt.mincover10.vcf \
        | sed -e 's/$/,En-Tibi/' > En-Tibi.csv

## Simplify and transform the 360 snps:

accessions=$(ls *.vcf.gz | sed -e 's/.vcf.gz//')
for acc in $accessions; do
	bcftools view --threads 3 -H -T ../../bam/mincover10.tsv $acc.vcf.gz \
		| tee $acc.mincover10.vcf \
		| egrep -v 'DP=\d;' \
		| perl gff2csv.pl \
		| sed -e "s/$/,$acc/" > $acc.csv

