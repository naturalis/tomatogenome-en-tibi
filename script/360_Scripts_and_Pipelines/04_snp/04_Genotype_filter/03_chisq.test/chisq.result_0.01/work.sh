#!/bin/sh
#$ -S /bin/sh
#Version1.0	lintao19870305@gmail.com	2013-10-19
echo Start Time : 
date
cat	../SL2.40ch01/*.out	|awk '$3<=0.01' |sort -k2,2n > SL2.40ch01_0.01.chisq.result
cat	../SL2.40ch02/*.out	|awk '$3<=0.01' |sort -k2,2n > SL2.40ch02_0.01.chisq.result
cat	../SL2.40ch03/*.out	|awk '$3<=0.01' |sort -k2,2n > SL2.40ch03_0.01.chisq.result
cat	../SL2.40ch04/*.out	|awk '$3<=0.01' |sort -k2,2n > SL2.40ch04_0.01.chisq.result
cat	../SL2.40ch05/*.out	|awk '$3<=0.01' |sort -k2,2n > SL2.40ch05_0.01.chisq.result
cat	../SL2.40ch06/*.out	|awk '$3<=0.01' |sort -k2,2n > SL2.40ch06_0.01.chisq.result
cat	../SL2.40ch07/*.out	|awk '$3<=0.01' |sort -k2,2n > SL2.40ch07_0.01.chisq.result
cat	../SL2.40ch08/*.out	|awk '$3<=0.01' |sort -k2,2n > SL2.40ch08_0.01.chisq.result
cat	../SL2.40ch09/*.out	|awk '$3<=0.01' |sort -k2,2n > SL2.40ch09_0.01.chisq.result
cat	../SL2.40ch10/*.out	|awk '$3<=0.01' |sort -k2,2n > SL2.40ch10_0.01.chisq.result
cat	../SL2.40ch11/*.out	|awk '$3<=0.01' |sort -k2,2n > SL2.40ch11_0.01.chisq.result
cat	../SL2.40ch12/*.out	|awk '$3<=0.01' |sort -k2,2n > SL2.40ch12_0.01.chisq.result
cat	../SL2.40ch00/*.out	|awk '$3<=0.01' |sort -k2,2n > SL2.40ch00_0.01.chisq.result
echo End Time : 
date
