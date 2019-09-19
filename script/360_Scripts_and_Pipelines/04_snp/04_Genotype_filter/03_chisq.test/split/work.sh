#!/bin/sh
#$ -S /bin/sh
#Version1.0	lintao19870305@gmail.com	2013-10-18
echo Start Time : 
date
perl	split.pl	../Total/SL2.40ch01.snp.stat	
perl	split.pl	../Total/SL2.40ch02.snp.stat	
perl	split.pl	../Total/SL2.40ch03.snp.stat	
perl	split.pl	../Total/SL2.40ch04.snp.stat	
perl	split.pl	../Total/SL2.40ch05.snp.stat	
perl	split.pl	../Total/SL2.40ch06.snp.stat	
perl	split.pl	../Total/SL2.40ch07.snp.stat	
perl	split.pl	../Total/SL2.40ch08.snp.stat	
perl	split.pl	../Total/SL2.40ch09.snp.stat	
perl	split.pl	../Total/SL2.40ch10.snp.stat	
perl	split.pl	../Total/SL2.40ch11.snp.stat	
perl	split.pl	../Total/SL2.40ch12.snp.stat	
perl	split.pl	../Total/SL2.40ch00.snp.stat	
echo End Time : 
date
