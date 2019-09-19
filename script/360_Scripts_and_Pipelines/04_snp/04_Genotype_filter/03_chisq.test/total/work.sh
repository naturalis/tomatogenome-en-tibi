#!/bin/sh
#$ -S /bin/sh
#Version1.0	lintao19870305@gmail.com	2013-10-17
echo Start Time : 
date
perl	chisq.test.pl	../Total/SL2.40ch01.snp.stat	../../02_snp_depth/raw/SL2.40ch01.raw	SL2.40ch01.result	
perl	chisq.test.pl	../Total/SL2.40ch02.snp.stat	../../02_snp_depth/raw/SL2.40ch02.raw	SL2.40ch02.result	
perl	chisq.test.pl	../Total/SL2.40ch03.snp.stat	../../02_snp_depth/raw/SL2.40ch03.raw	SL2.40ch03.result	
perl	chisq.test.pl	../Total/SL2.40ch04.snp.stat	../../02_snp_depth/raw/SL2.40ch04.raw	SL2.40ch04.result	
perl	chisq.test.pl	../Total/SL2.40ch05.snp.stat	../../02_snp_depth/raw/SL2.40ch05.raw	SL2.40ch05.result	
perl	chisq.test.pl	../Total/SL2.40ch06.snp.stat	../../02_snp_depth/raw/SL2.40ch06.raw	SL2.40ch06.result	
perl	chisq.test.pl	../Total/SL2.40ch07.snp.stat	../../02_snp_depth/raw/SL2.40ch07.raw	SL2.40ch07.result	
perl	chisq.test.pl	../Total/SL2.40ch08.snp.stat	../../02_snp_depth/raw/SL2.40ch08.raw	SL2.40ch08.result	
perl	chisq.test.pl	../Total/SL2.40ch09.snp.stat	../../02_snp_depth/raw/SL2.40ch09.raw	SL2.40ch09.result	
perl	chisq.test.pl	../Total/SL2.40ch10.snp.stat	../../02_snp_depth/raw/SL2.40ch10.raw	SL2.40ch10.result	
perl	chisq.test.pl	../Total/SL2.40ch11.snp.stat	../../02_snp_depth/raw/SL2.40ch11.raw	SL2.40ch11.result	
perl	chisq.test.pl	../Total/SL2.40ch12.snp.stat	../../02_snp_depth/raw/SL2.40ch12.raw	SL2.40ch12.result	
perl	chisq.test.pl	../Total/SL2.40ch00.snp.stat	../../02_snp_depth/raw/SL2.40ch00.raw	SL2.40ch00.result	
echo End Time : 
date
