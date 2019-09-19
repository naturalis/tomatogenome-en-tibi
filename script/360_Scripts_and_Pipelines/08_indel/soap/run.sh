#!/bin/sh
#$ -S /bin/sh
#Version1.0	wanglei4@genomics.org.cn	2011-02-17
echo Start Time : 
date
perl	run_soap_flow_PE.pl	-fqlist	all.fq.list	-ref	/share/fg1/lintao/format/S_lycopersicum_chromosomes.2.40.fa.index	-BinDir /share/fg1/lintao/solab/lintao/tomato/03_soap/bin 	-gap 5 -mem 2.5G -runIndel 
echo End Time : 
date
