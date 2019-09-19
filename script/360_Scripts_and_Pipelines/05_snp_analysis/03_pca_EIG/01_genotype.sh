#!/bin/sh
#$ -S /bin/sh
#Version1.0	zengpeng@genomics.org.cn	2012-03-15
echo Start Time : 
date
perl	bin/change_geno.pl	/share/fg3/lintao/solab/lintao/tomato/06_snp_analysis/03_pca_EIG/three_pop_genotype/Chr1_three.add.ref_mis0.1_maf_0.05
perl	bin/change_geno.pl	/share/fg3/lintao/solab/lintao/tomato/06_snp_analysis/03_pca_EIG/three_pop_genotype/Chr2_three.add.ref_mis0.1_maf_0.05
perl	bin/change_geno.pl	/share/fg3/lintao/solab/lintao/tomato/06_snp_analysis/03_pca_EIG/three_pop_genotype/Chr3_three.add.ref_mis0.1_maf_0.05
perl	bin/change_geno.pl	/share/fg3/lintao/solab/lintao/tomato/06_snp_analysis/03_pca_EIG/three_pop_genotype/Chr4_three.add.ref_mis0.1_maf_0.05
perl	bin/change_geno.pl	/share/fg3/lintao/solab/lintao/tomato/06_snp_analysis/03_pca_EIG/three_pop_genotype/Chr5_three.add.ref_mis0.1_maf_0.05
perl	bin/change_geno.pl	/share/fg3/lintao/solab/lintao/tomato/06_snp_analysis/03_pca_EIG/three_pop_genotype/Chr6_three.add.ref_mis0.1_maf_0.05
perl	bin/change_geno.pl	/share/fg3/lintao/solab/lintao/tomato/06_snp_analysis/03_pca_EIG/three_pop_genotype/Chr7_three.add.ref_mis0.1_maf_0.05
perl	bin/change_geno.pl	/share/fg3/lintao/solab/lintao/tomato/06_snp_analysis/03_pca_EIG/three_pop_genotype/Chr8_three.add.ref_mis0.1_maf_0.05
perl	bin/change_geno.pl	/share/fg3/lintao/solab/lintao/tomato/06_snp_analysis/03_pca_EIG/three_pop_genotype/Chr9_three.add.ref_mis0.1_maf_0.05
perl	bin/change_geno.pl	/share/fg3/lintao/solab/lintao/tomato/06_snp_analysis/03_pca_EIG/three_pop_genotype/Chr10_three.add.ref_mis0.1_maf_0.05
perl	bin/change_geno.pl	/share/fg3/lintao/solab/lintao/tomato/06_snp_analysis/03_pca_EIG/three_pop_genotype/Chr11_three.add.ref_mis0.1_maf_0.05
perl	bin/change_geno.pl	/share/fg3/lintao/solab/lintao/tomato/06_snp_analysis/03_pca_EIG/three_pop_genotype/Chr12_three.add.ref_mis0.1_maf_0.05
perl	bin/change_geno.pl	/share/fg3/lintao/solab/lintao/tomato/06_snp_analysis/03_pca_EIG/three_pop_genotype/Chr0_three.add.ref_mis0.1_maf_0.05
echo End Time : 
date
