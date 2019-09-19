#!/bin/sh
#$ -S /bin/sh
#Version1.0	lintao19870305@gmail.com	2013-10-16
echo Start Time : 
date
perl	individual_number.pl	genotype_add_ref/SL2.40ch01.FinalSNPs	>	SL2.40ch01_individual_number.st	
perl	individual_number.pl	genotype_add_ref/SL2.40ch02.FinalSNPs	>	SL2.40ch02_individual_number.st	
perl	individual_number.pl	genotype_add_ref/SL2.40ch03.FinalSNPs	>	SL2.40ch03_individual_number.st	
perl	individual_number.pl	genotype_add_ref/SL2.40ch04.FinalSNPs	>	SL2.40ch04_individual_number.st	
perl	individual_number.pl	genotype_add_ref/SL2.40ch05.FinalSNPs	>	SL2.40ch05_individual_number.st	
perl	individual_number.pl	genotype_add_ref/SL2.40ch06.FinalSNPs	>	SL2.40ch06_individual_number.st	
perl	individual_number.pl	genotype_add_ref/SL2.40ch07.FinalSNPs	>	SL2.40ch07_individual_number.st	
perl	individual_number.pl	genotype_add_ref/SL2.40ch08.FinalSNPs	>	SL2.40ch08_individual_number.st	
perl	individual_number.pl	genotype_add_ref/SL2.40ch09.FinalSNPs	>	SL2.40ch09_individual_number.st	
perl	individual_number.pl	genotype_add_ref/SL2.40ch10.FinalSNPs	>	SL2.40ch10_individual_number.st	
perl	individual_number.pl	genotype_add_ref/SL2.40ch11.FinalSNPs	>	SL2.40ch11_individual_number.st	
perl	individual_number.pl	genotype_add_ref/SL2.40ch12.FinalSNPs	>	SL2.40ch12_individual_number.st	
perl	individual_number.pl	genotype_add_ref/SL2.40ch00.FinalSNPs	>	SL2.40ch00_individual_number.st	
echo End Time : 
date
