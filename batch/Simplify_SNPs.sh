#!/bin/bash

#SBATCH --job-name=simplify
#SBATCH --output=output_simplify.txt

echo "Simplify the En Tibi snps"

#    bcftools view --threads 3 -H -T output_Index_high_coverage.txt \
#	paired_En-Tibi.fixmate.sorted.markdup.flt.vcf \
#        | grep -v LowQual \
#        | egrep -v 'DP=\d;' \
#        | grep -v INDEL > paired_En-Tibi.fixmate.sorted.markdup.flt.mincover10.vcf

    bcftools view --threads 3 -H -e 'DP<10' -T output_Index_high_coverage.txt \
	paired_En-Tibi.fixmate.sorted.markdup.flt.vcf \
        | grep -v LowQual \
        | grep -v INDEL \
	> paired_En-Tibi.fixmate.sorted.markdup.flt.mincover10.vcf

