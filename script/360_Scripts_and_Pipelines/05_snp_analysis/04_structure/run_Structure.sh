#!/bin/sh
#$ -S /bin/sh
#Version1.0	lintao19870305@gmail.com	2013-10-20

BinDir=/share/fg1/lintao/05_snp_analysis/04_structure/bin
OutDir=`pwd`
individual=$OutDir/individual.txt
all_snp=$OutDir/tomato.4d.snp.list
usage()
{
    echo "usage:sh $0  individual.txt  add_ref.list  OutDir "
}

if [ $# -eq 3 ]
then
    individual=$1
    all_snp=$2
    OutDir=$3
elif [ $# -eq 2 ]
then
    individual=$1
    all_snp=$2
elif [ $# -eq 1 ]
then
    individual=$1
fi


if [ -s $all_snp ]; then
    :
else
    usage
    exit 1
fi

if [ -s $individual  ]; then
    :
else
    usage
    exit 1
fi

USePosition=$OutDir/all_snp
echo Start Time :
date
ls  $OutDir/structure*/result*_f  > $OutDir/result.list 2> $OutDir/bad.log
if [ -s  $OutDir/result.list ] ; then
   perl $BinDir/result_report.pl  $OutDir/result.list $individual $OutDir/final.out
   rm -f $OutDir/bad.log  $OutDir/result.list   
   echo pls check the result
   echo $OutDir/final.out
   echo End Time :
   date
   exit 1
else
    echo after the Structure shell run out , pls sh $0 again
    rm -f $OutDir/bad.log  $OutDir/result.list    
fi

perl $BinDir/all_cov.pl   $all_snp  $USePosition
perl $BinDir/get_structure_input.pl	$USePosition $individual $OutDir/Input.file
sample_num=`wc -l $individual | cut  -f 1 -d " " | tr -d '\n' `
location_num=`wc -l $USePosition  | cut  -f 1 -d " " | tr -d '\n' `
if [ $location_num -gt 680000 ] 
then
    perl $BinDir/rand_small_position.pl $USePosition  $OutDir/temp 680000
else
    :
fi
location_num=`wc -l $USePosition  | cut  -f 1 -d " " | tr -d '\n' `
perl	$BinDir/new_mainparams.pl	-output	 $OutDir 	-input	$BinDir 	-loca	$location_num	-sample	$sample_num
sh	$BinDir/Start.sh	 $OutDir
echo End Time : 
date
##########swimming in the sky and flying in the sea ###################
