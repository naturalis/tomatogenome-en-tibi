#!/bin/sh
#$ -S /bin/sh
#Version1.0	lintao1987035@gmail.com	2013-11-23
echo Start Time : 
date
perl	same.pl	tomato.cds.4d	../../04_final_snp/SL2.40ch01.final.genotype	SL2.40ch01	>	SL2.40ch01.4d.snp	
echo End Time : 
date
