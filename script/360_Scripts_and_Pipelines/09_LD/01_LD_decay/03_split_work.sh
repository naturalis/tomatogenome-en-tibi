#!/bin/sh
#$ -S /bin/sh
#Version1.0     lintao19870305@gmail.com		2014-08-10
echo Start Time :
date

for i in {0..12}
do 
	mkdir -p big_split_window/chr$i;
	../bin/split_window.py -i chr$i\_big_mis0.4_maf5.genotype -win 2000000 -len ../tomato.len -chr $i -o big_split_window/chr$i;
	mv big_split_window/chr$i\_* big_split_window/chr$i;
done

date
