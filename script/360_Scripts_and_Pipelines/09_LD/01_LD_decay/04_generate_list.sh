for i in {0..12}
do
	for j in `ls -d big_split_window/chr$i/*`
	do
		echo "/home/lintao/10_LD/01_LD_decay/big/$j";
	done
done
