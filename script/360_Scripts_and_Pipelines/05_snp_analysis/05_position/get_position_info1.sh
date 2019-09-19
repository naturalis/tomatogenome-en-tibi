#!/bin/sh
#$ -S /bin/sh
#Version1.0	lintao19870205@gmail.com	2013-11-13
echo Start Time : 
date
perl	identify_snp_position.pl	rep.gff	../SL2.40ch01.final.genotype	SL2.40ch01	>	SL2.40ch01.snp.info
perl	identify_snp_position.pl	rep.gff	../SL2.40ch02.final.genotype	SL2.40ch02	>	SL2.40ch02.snp.info
perl	identify_snp_position.pl	rep.gff	../SL2.40ch03.final.genotype	SL2.40ch03	>	SL2.40ch03.snp.info
perl	identify_snp_position.pl	rep.gff	../SL2.40ch04.final.genotype	SL2.40ch04	>	SL2.40ch04.snp.info
perl	identify_snp_position.pl	rep.gff	../SL2.40ch05.final.genotype	SL2.40ch05	>	SL2.40ch05.snp.info
perl	identify_snp_position.pl	rep.gff	../SL2.40ch06.final.genotype	SL2.40ch06	>	SL2.40ch06.snp.info
perl	identify_snp_position.pl	rep.gff	../SL2.40ch07.final.genotype	SL2.40ch07	>	SL2.40ch07.snp.info
perl	identify_snp_position.pl	rep.gff	../SL2.40ch08.final.genotype	SL2.40ch08	>	SL2.40ch08.snp.info
perl	identify_snp_position.pl	rep.gff	../SL2.40ch09.final.genotype	SL2.40ch09	>	SL2.40ch09.snp.info
perl	identify_snp_position.pl	rep.gff	../SL2.40ch10.final.genotype	SL2.40ch10	>	SL2.40ch10.snp.info
perl	identify_snp_position.pl	rep.gff	../SL2.40ch11.final.genotype	SL2.40ch11	>	SL2.40ch11.snp.info
perl	identify_snp_position.pl	rep.gff	../SL2.40ch12.final.genotype	SL2.40ch12	>	SL2.40ch12.snp.info
perl	identify_snp_position.pl	rep.gff	../SL2.40ch00.final.genotype	SL2.40ch00	>	SL2.40ch00.snp.info
echo End Time : 
date
