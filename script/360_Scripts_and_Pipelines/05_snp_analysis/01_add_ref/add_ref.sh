#!/bin/sh
#$ -S /bin/sh
#Version1.0	zengpeng@genomics.org.cn	2012-04-2
echo Start Time : 
date
perl	GenotypeSnp_add_ref.pl	../02_annotation/snp_location_info/Chr1.final.genotype_cp	chromosome/chr01.fa	Chr1.FinalSNPs.add.ref
perl	GenotypeSnp_add_ref.pl	../02_annotation/snp_location_info/Chr2.final.genotype_cp	chromosome/chr02.fa	Chr2.FinalSNPs.add.ref
perl	GenotypeSnp_add_ref.pl	../02_annotation/snp_location_info/Chr3.final.genotype_cp	chromosome/chr03.fa	Chr3.FinalSNPs.add.ref
perl	GenotypeSnp_add_ref.pl	../02_annotation/snp_location_info/Chr4.final.genotype_cp	chromosome/chr04.fa	Chr4.FinalSNPs.add.ref
perl	GenotypeSnp_add_ref.pl	../02_annotation/snp_location_info/Chr5.final.genotype_cp	chromosome/chr05.fa	Chr5.FinalSNPs.add.ref
perl	GenotypeSnp_add_ref.pl	../02_annotation/snp_location_info/Chr6.final.genotype_cp	chromosome/chr06.fa	Chr6.FinalSNPs.add.ref
perl	GenotypeSnp_add_ref.pl	../02_annotation/snp_location_info/Chr7.final.genotype_cp	chromosome/chr07.fa	Chr7.FinalSNPs.add.ref
perl	GenotypeSnp_add_ref.pl	../02_annotation/snp_location_info/Chr8.final.genotype_cp	chromosome/chr08.fa	Chr8.FinalSNPs.add.ref
perl	GenotypeSnp_add_ref.pl	../02_annotation/snp_location_info/Chr9.final.genotype_cp	chromosome/chr09.fa	Chr9.FinalSNPs.add.ref
perl	GenotypeSnp_add_ref.pl	../02_annotation/snp_location_info/Chr10.final.genotype_cp	chromosome/chr10.fa	Chr10.FinalSNPs.add.ref
perl	GenotypeSnp_add_ref.pl	../02_annotation/snp_location_info/Chr11.final.genotype_cp	chromosome/chr11.fa	Chr11.FinalSNPs.add.ref
perl	GenotypeSnp_add_ref.pl	../02_annotation/snp_location_info/Chr12.final.genotype_cp	chromosome/chr12.fa	Chr12.FinalSNPs.add.ref
perl	GenotypeSnp_add_ref.pl	../02_annotation/snp_location_info/Chr0.final.genotype_cp	chromosome/chr00.fa	Chr00.FinalSNPs.add.ref
echo End Time : 
date
