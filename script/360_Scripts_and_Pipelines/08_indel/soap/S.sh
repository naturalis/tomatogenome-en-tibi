#!/bin/sh
#$ -S /bin/sh
#Version1.0	lintao@genomics.org.cn	2014-01-18
echo Start Time : 
date
/share/fg1/lintao/solab/lintao/tomato/03_soap/bin/soap2.21.xd	-a	-b	-D	/share/fg1/lintao/format/S_lycopersicum_chromosomes.2.40.fa.index	-m	100	-x	888	-s	35	-l	32	-v	3	-g	5	-p	4	-o	/share/fg1/lintao/solab/lintao/tomato/09_indel/soap//.soap	-2	/share/fg1/lintao/solab/lintao/tomato/09_indel/soap//.single	
ls	/share/fg1/lintao/solab/lintao/tomato/09_indel/soap//.soap	/share/fg1/lintao/solab/lintao/tomato/09_indel/soap//.single	>	/share/fg1/lintao/solab/lintao/tomato/09_indel/soap//soap.list	
/share/fg1/lintao/solab/lintao/tomato/03_soap/bin/soapInDelV1.08	-s	/share/fg1/lintao/solab/lintao/tomato/09_indel/soap//soap.list	-f	/share/fg1/lintao/format/S_lycopersicum_chromosomes.2.40.fa	-o	/share/fg1/lintao/solab/lintao/tomato/09_indel/soap//indel-result.list	
echo End Time : 
date
