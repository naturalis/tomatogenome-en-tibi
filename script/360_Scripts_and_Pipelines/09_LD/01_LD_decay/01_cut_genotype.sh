#!/bin/sh
#$ -S /bin/sh
#Version1.0	zengpeng@genomics.org.cn	2012-10-31
echo Start Time : 
date
perl  ../bin/cut_genotype.pl  ../individual_new_change_filter.txt  ../../genotype/Chr0.final.genotype_cp  big  > chr0_big.genotype	
perl  ../bin/cut_genotype.pl  ../individual_new_change_filter.txt  ../../genotype/Chr1.final.genotype_cp  big  > chr1_big.genotype	
perl  ../bin/cut_genotype.pl  ../individual_new_change_filter.txt  ../../genotype/Chr2.final.genotype_cp  big  > chr2_big.genotype	
perl  ../bin/cut_genotype.pl  ../individual_new_change_filter.txt  ../../genotype/Chr3.final.genotype_cp  big  > chr3_big.genotype	
perl  ../bin/cut_genotype.pl  ../individual_new_change_filter.txt  ../../genotype/Chr4.final.genotype_cp  big  > chr4_big.genotype	
perl  ../bin/cut_genotype.pl  ../individual_new_change_filter.txt  ../../genotype/Chr5.final.genotype_cp  big  > chr5_big.genotype	
perl  ../bin/cut_genotype.pl  ../individual_new_change_filter.txt  ../../genotype/Chr6.final.genotype_cp  big  > chr6_big.genotype	
perl  ../bin/cut_genotype.pl  ../individual_new_change_filter.txt  ../../genotype/Chr7.final.genotype_cp  big  > chr7_big.genotype	
perl  ../bin/cut_genotype.pl  ../individual_new_change_filter.txt  ../../genotype/Chr8.final.genotype_cp  big  > chr8_big.genotype	
perl  ../bin/cut_genotype.pl  ../individual_new_change_filter.txt  ../../genotype/Chr9.final.genotype_cp  big  > chr9_big.genotype	
perl  ../bin/cut_genotype.pl  ../individual_new_change_filter.txt  ../../genotype/Chr10.final.genotype_cp  big  > chr10_big.genotype	
perl  ../bin/cut_genotype.pl  ../individual_new_change_filter.txt  ../../genotype/Chr11.final.genotype_cp  big  > chr11_big.genotype	
perl  ../bin/cut_genotype.pl  ../individual_new_change_filter.txt  ../../genotype/Chr12.final.genotype_cp  big  > chr12_big.genotype	
echo End Time : 
date
