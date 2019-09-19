#!/bin/sh
#$ -S /bin/sh
#Version1.0     hewm@genomics.org.cn    2009-12-3
usage ()
{
     echo "usage: $0 <Dir>  "
     echo "usage: sh $0  pwdDir run  "
}
if [ $# -ne 2 ]; then
    usage
    exit 1 ;
fi
echo Start Time :
date
BinDir=/ifs1/ST_PLANT/USER/wangwl/bin/04.resequencing/Population/StructureBin/bin


cd   $1/structure_K02
rm  -f     *.sh.*
perl    $BinDir/osh.pl  02  02   s_$2_K02   $1/structure_K02/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K02.sh

cd   $1/structure_K03
rm  -f     *.sh.*
perl    $BinDir/osh.pl  03  03   s_$2_K03   $1/structure_K03/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K03.sh

cd   $1/structure_K04
rm  -f     *.sh.*
perl    $BinDir/osh.pl  04  04   s_$2_K04   $1/structure_K04/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K04.sh

cd   $1/structure_K05
rm  -f     *.sh.*
perl    $BinDir/osh.pl  05  05   s_$2_K05   $1/structure_K05/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K05.sh

cd   $1/structure_K06
rm  -f     *.sh.*
perl    $BinDir/osh.pl  06  06   s_$2_K06   $1/structure_K06/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K06.sh

cd   $1/structure_K07
rm  -f     *.sh.*
perl    $BinDir/osh.pl  07  07   s_$2_K07   $1/structure_K07/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K07.sh

cd   $1/structure_K08
rm  -f     *.sh.*
perl    $BinDir/osh.pl  08  08   s_$2_K08   $1/structure_K08/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K08.sh

cd   $1/structure_K09
rm  -f     *.sh.*
perl    $BinDir/osh.pl  09  09   s_$2_K09   $1/structure_K09/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K09.sh

cd   $1/structure_K10
rm  -f     *.sh.*
perl    $BinDir/osh.pl  10  10   s_$2_K10   $1/structure_K10/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K10.sh

cd   $1/structure_K11
rm  -f     *.sh.*
perl    $BinDir/osh.pl  11  11   s_$2_K11   $1/structure_K11/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K11.sh

cd   $1/structure_K12
rm  -f     *.sh.*
perl    $BinDir/osh.pl  12  12   s_$2_K12   $1/structure_K12/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K12.sh

cd   $1/structure_K13
rm  -f     *.sh.*
perl    $BinDir/osh.pl  13  13   s_$2_K13   $1/structure_K13/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K13.sh

cd   $1/structure_K14
rm  -f     *.sh.*
perl    $BinDir/osh.pl  14  14   s_$2_K14   $1/structure_K14/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K14.sh

cd   $1/structure_K15
rm  -f     *.sh.*
perl    $BinDir/osh.pl  15  15   s_$2_K15   $1/structure_K15/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K15.sh

cd   $1/structure_K16
rm  -f     *.sh.*
perl    $BinDir/osh.pl  16  16   s_$2_K16   $1/structure_K16/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K16.sh

cd   $1/structure_K17
rm  -f     *.sh.*
perl    $BinDir/osh.pl  17  17   s_$2_K17   $1/structure_K17/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K17.sh

cd   $1/structure_K18
rm  -f     *.sh.*
perl    $BinDir/osh.pl  18  18   s_$2_K18   $1/structure_K18/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K18.sh

cd   $1/structure_K19
rm  -f     *.sh.*
perl    $BinDir/osh.pl  19  19   s_$2_K19   $1/structure_K19/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K19.sh

cd   $1/structure_K20
rm  -f     *.sh.*
perl    $BinDir/osh.pl  20  20   s_$2_K20   $1/structure_K20/structure.exe
qsub -P st_breeding -q st.q     -cwd    -l      vf=500M   -S      /bin/sh s_$2_K20.sh


echo End Time :
date

