#!/bin/sh
#$ -S /bin/sh
#Version1.0	lintao19870305@gmail.com	2014-02-10
echo Start Time : 
date

perl cat.pl sample.list indel_result/ SL2.40ch01 >SL2.40ch01.indel
perl cat.pl sample.list indel_result/ SL2.40ch02 >SL2.40ch02.indel
perl cat.pl sample.list indel_result/ SL2.40ch03 >SL2.40ch03.indel
perl cat.pl sample.list indel_result/ SL2.40ch04 >SL2.40ch04.indel
perl cat.pl sample.list indel_result/ SL2.40ch05 >SL2.40ch05.indel
perl cat.pl sample.list indel_result/ SL2.40ch06 >SL2.40ch06.indel
perl cat.pl sample.list indel_result/ SL2.40ch07 >SL2.40ch07.indel
perl cat.pl sample.list indel_result/ SL2.40ch08 >SL2.40ch08.indel
perl cat.pl sample.list indel_result/ SL2.40ch09 >SL2.40ch09.indel
perl cat.pl sample.list indel_result/ SL2.40ch10 >SL2.40ch10.indel
perl cat.pl sample.list indel_result/ SL2.40ch11 >SL2.40ch11.indel
perl cat.pl sample.list indel_result/ SL2.40ch12 >SL2.40ch12.indel
perl cat.pl sample.list indel_result/ SL2.40ch00 >SL2.40ch00.indel

echo End Time : 
date
