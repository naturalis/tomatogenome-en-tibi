#!/bin/sh
#$ -S /bin/sh
#Version1.0	hewm@genomics.org.cn	2009-12-3
usage ()
{
     echo "usage: $0 <Dir>  "
     echo "usage: sh $0  pwdDir "
}
if [ $# -ne 1 ]; then
    usage
    exit 1 ;
fi
echo Start Time :
date
BinDir=/ifs1/ST_PLANT/USER/wangwl/bin/04.resequencing/Population/StructureBin/bin

cd	$1/structure_K02	
 rm  -f 	*.sh.*	
perl	$BinDir/osh.pl	02	02	s_K02	$1/structure_K02/structure.exe	
qsub -P st_breeding -q st.q 	-cwd	-l	vf=3G	-S	/bin/sh	s_K02.sh	

cd	$1/structure_K03	
    rm -f 	*.sh.*	
perl	$BinDir/osh.pl	03	03	s_K03	$1/structure_K03/structure.exe	
qsub -P st_breeding -q st.q 	-cwd	-l	vf=3G	-S	/bin/sh	s_K03.sh	

cd	$1/structure_K04	
    rm -f 	*.sh.*	
perl	$BinDir/osh.pl	04	04	s_K04	$1/structure_K04/structure.exe	
qsub -P st_breeding -q st.q 	-cwd	-l	vf=3G	-S	/bin/sh	s_K04.sh	


cd	$1/structure_K05	
    rm -f 	*.sh.*	
perl	$BinDir/osh.pl	05	05	s_K05	$1/structure_K05/structure.exe	
qsub -P st_breeding -q st.q 	-cwd	-l	vf=3G	-S	/bin/sh	s_K05.sh	


cd	$1/structure_K06	
    rm -f	*.sh.*	
perl	$BinDir/osh.pl	06	06	s_K06	$1/structure_K06/structure.exe	
qsub -P st_breeding -q st.q 	-cwd	-l	vf=3G	-S	/bin/sh	s_K06.sh	

    rm	-f *.sh.*	
perl	$BinDir/osh.pl	07	07	s_K07	$1/structure_K07/structure.exe	
qsub -P st_breeding -q st.q 	-cwd	-l	vf=3G	-S	/bin/sh	s_K07.sh
echo End Time : 
date


