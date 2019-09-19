#!/bin/sh
#$ -S /bin/sh
#Version1.0	lintao19870305@gmail.com	2013-08-03
echo Start Time : 
date
perl	/share/fg4/lintao/01_reference/bin/RefLeng.pl	/share/fg4/lintao/01_reference/S_lycopersicum_chromosomes.2.40
perl	/share/fg4/lintao/01_reference/bin/Ref2Chr.pl	/share/fg4/lintao/01_reference/S_lycopersicum_chromosomes.2.40
/share/fg4/lintao/01_reference/bin/2bwt-builder	/share/fg4/lintao/01_reference/S_lycopersicum_chromosomes.2.40
perl	/share/fg4/lintao/01_reference/bin/find_Fa_N_region.pl	/share/fg4/lintao/01_reference/S_lycopersicum_chromosomes.2.40	
echo End Time : 
date
