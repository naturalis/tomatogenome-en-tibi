#!/bin/sh
#$ -S /bin/sh
#Version1.0	lintao19870305@gmail.com	2013-10-19
echo Start Time : 
date
perl	final_snp.pl	chisq/SL2.40ch01_0.01.snp.chisq.result	fish/SL2.40ch01.fish	genotype/SL2.40ch01.genotype	>	SL2.40ch01.final.genotype	
perl	final_snp.pl	chisq/SL2.40ch02_0.01.snp.chisq.result	fish/SL2.40ch02.fish	genotype/SL2.40ch02.genotype	>	SL2.40ch02.final.genotype	
perl	final_snp.pl	chisq/SL2.40ch03_0.01.snp.chisq.result	fish/SL2.40ch03.fish	genotype/SL2.40ch03.genotype	>	SL2.40ch03.final.genotype	
perl	final_snp.pl	chisq/SL2.40ch04_0.01.snp.chisq.result	fish/SL2.40ch04.fish	genotype/SL2.40ch04.genotype	>	SL2.40ch04.final.genotype	
perl	final_snp.pl	chisq/SL2.40ch05_0.01.snp.chisq.result	fish/SL2.40ch05.fish	genotype/SL2.40ch05.genotype	>	SL2.40ch05.final.genotype	
perl	final_snp.pl	chisq/SL2.40ch06_0.01.snp.chisq.result	fish/SL2.40ch06.fish	genotype/SL2.40ch06.genotype	>	SL2.40ch06.final.genotype	
perl	final_snp.pl	chisq/SL2.40ch07_0.01.snp.chisq.result	fish/SL2.40ch07.fish	genotype/SL2.40ch07.genotype	>	SL2.40ch07.final.genotype	
perl	final_snp.pl	chisq/SL2.40ch08_0.01.snp.chisq.result	fish/SL2.40ch08.fish	genotype/SL2.40ch08.genotype	>	SL2.40ch08.final.genotype	
perl	final_snp.pl	chisq/SL2.40ch09_0.01.snp.chisq.result	fish/SL2.40ch09.fish	genotype/SL2.40ch09.genotype	>	SL2.40ch09.final.genotype	
perl	final_snp.pl	chisq/SL2.40ch10_0.01.snp.chisq.result	fish/SL2.40ch10.fish	genotype/SL2.40ch10.genotype	>	SL2.40ch10.final.genotype	
perl	final_snp.pl	chisq/SL2.40ch11_0.01.snp.chisq.result	fish/SL2.40ch11.fish	genotype/SL2.40ch11.genotype	>	SL2.40ch11.final.genotype	
perl	final_snp.pl	chisq/SL2.40ch12_0.01.snp.chisq.result	fish/SL2.40ch12.fish	genotype/SL2.40ch12.genotype	>	SL2.40ch12.final.genotype	
perl	final_snp.pl	chisq/SL2.40ch00_0.01.snp.chisq.result	fish/SL2.40ch00.fish	genotype/SL2.40ch00.genotype	>	SL2.40ch00.final.genotype	
echo End Time : 
date
