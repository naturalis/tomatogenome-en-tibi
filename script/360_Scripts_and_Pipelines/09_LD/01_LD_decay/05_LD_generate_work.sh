sh 04_generate_list.sh >genotype.list
perl ../bin/LD_decay_flow_v1.01.pl  -input genotype.list -outDir /home/lintao/10_LD/01_LD_decay/big -qsub -maxdis 2000 -maf 0.05 -hwcutoff 0.0
