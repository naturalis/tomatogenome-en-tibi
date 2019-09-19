for i in {1..20} 
do
	./run_simulate3D_one_split_mig.py -i ../../../../02.fs/random$i >>run_simulate3D_shell.sh;
#	/home/mudesheng/bin/python2.7 run_random$i\_pimp.py >>random_Pimp.result;
#	/home/mudesheng/bin/python2.7 run_random$i\_cerasi.py >>random_cerasi.result;
#	/home/mudesheng/bin/python2.7 run_random$i\_big.py >>random_big.result;
done
