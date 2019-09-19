#!/bin/sh
#$ -S /bin/sh
#Version1.0	lintao19870305@gmail.com	2013-10-16
echo Start Time : 
date
perl	gather_snp.pl	individual.txt	/share/fg4/lintao/tomato/05_base_depth_stat	/share/fg4/lintao/tomato/04_snp/03_Genotype/SL2.40ch01.genotype	SL2.40ch01	
perl	gather_snp.pl	individual.txt	/share/fg4/lintao/tomato/05_base_depth_stat	/share/fg4/lintao/tomato/04_snp/03_Genotype/SL2.40ch02.genotype	SL2.40ch02	
perl	gather_snp.pl	individual.txt	/share/fg4/lintao/tomato/05_base_depth_stat	/share/fg4/lintao/tomato/04_snp/03_Genotype/SL2.40ch03.genotype	SL2.40ch03	
perl	gather_snp.pl	individual.txt	/share/fg4/lintao/tomato/05_base_depth_stat	/share/fg4/lintao/tomato/04_snp/03_Genotype/SL2.40ch04.genotype	SL2.40ch04	
perl	gather_snp.pl	individual.txt	/share/fg4/lintao/tomato/05_base_depth_stat	/share/fg4/lintao/tomato/04_snp/03_Genotype/SL2.40ch05.genotype	SL2.40ch05	
perl	gather_snp.pl	individual.txt	/share/fg4/lintao/tomato/05_base_depth_stat	/share/fg4/lintao/tomato/04_snp/03_Genotype/SL2.40ch06.genotype	SL2.40ch06	
perl	gather_snp.pl	individual.txt	/share/fg4/lintao/tomato/05_base_depth_stat	/share/fg4/lintao/tomato/04_snp/03_Genotype/SL2.40ch07.genotype	SL2.40ch07	
perl	gather_snp.pl	individual.txt	/share/fg4/lintao/tomato/05_base_depth_stat	/share/fg4/lintao/tomato/04_snp/03_Genotype/SL2.40ch08.genotype	SL2.40ch08	
perl	gather_snp.pl	individual.txt	/share/fg4/lintao/tomato/05_base_depth_stat	/share/fg4/lintao/tomato/04_snp/03_Genotype/SL2.40ch09.genotype	SL2.40ch09
perl	gather_snp.pl	individual.txt	/share/fg4/lintao/tomato/05_base_depth_stat	/share/fg4/lintao/tomato/04_snp/03_Genotype/SL2.40ch10.genotype	SL2.40ch10	
perl	gather_snp.pl	individual.txt	/share/fg4/lintao/tomato/05_base_depth_stat	/share/fg4/lintao/tomato/04_snp/03_Genotype/SL2.40ch11.genotype	SL2.40ch11	
perl	gather_snp.pl	individual.txt	/share/fg4/lintao/tomato/05_base_depth_stat	/share/fg4/lintao/tomato/04_snp/03_Genotype/SL2.40ch12.genotype	SL2.40ch12	
perl	gather_snp.pl	individual.txt	/share/fg4/lintao/tomato/05_base_depth_stat	/share/fg4/lintao/tomato/04_snp/03_Genotype/SL2.40ch00.genotype	SL2.40ch00	
echo End Time : 
date
