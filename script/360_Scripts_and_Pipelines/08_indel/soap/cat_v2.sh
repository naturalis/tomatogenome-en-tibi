for i in `ls -d /share/fg1/lintao/solab/lintao/tomato/09_indel/soap/TS*`
{
#	echo -n "$i ";
	for m in `ls $i | wc -l`
	{
	#echo $m
	if [ $m -ne 2 ];then 
		echo -n "cat "
		for j in `ls $i`
		{
		if echo "$j"|grep -q "R1";then echo -n "$i/$j ";fi
		}
		echo ">merge_${j%%_*}_R1.clean${j##*clean}"
	fi
	}
}

for i in `ls -d /share/fg1/lintao/solab/lintao/tomato/09_indel/soap/TS*`
{
#	echo -n "$i ";
	for m in `ls $i | wc -l`
	{
	#echo $m
	if [ $m -ne 2 ];then 	#pay attention to backsapce
		echo -n "cat "
		for j in `ls $i`
		{
		if echo "$j"|grep -q "R2";then echo -n "$i/$j ";fi
		}
		echo ">merge_${j%%_*}_R2.clean${j##*clean}"
	fi
	}
}

