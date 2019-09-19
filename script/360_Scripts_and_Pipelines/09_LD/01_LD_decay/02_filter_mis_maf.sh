for i in {0..12}
do 
	../bin/filter_mis_maf.py -i chr$i\_big.genotype -r 0.40 -maf 0.05 -o chr$i\_big_mis0.4_maf5.genotype;
done
