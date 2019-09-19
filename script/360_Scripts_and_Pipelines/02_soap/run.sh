#!/bin/sh
#$ -S /bin/sh
#Version1.0	lintao19870305@gmail.com	2013-08-18
echo Start Time : 
date
perl	run_soap_flow_PE.pl	-fqlist	all.fq.list	-ref	/share/fg4/lintao/01_reference/S_lycopersicum_chromosomes.2.40.index	-BinDir /share/fg4/lintao/02_soap/Soap 	-qsub
echo End Time : 
date
