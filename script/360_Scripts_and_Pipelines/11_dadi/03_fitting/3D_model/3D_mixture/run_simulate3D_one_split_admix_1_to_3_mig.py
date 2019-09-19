#!/usr/local/bin/python3
#Program name: run_simulate1D.py
###Program information###
#	version: 1.0				author: lintao <lintao19870305@gmail.com>		date: 2013-11-19
"""
				module description
								version: 1.0 author: lintao <lintao19870305@gmail.com>		date: 2013-11-19
"""

#include the required module
import sys
import re
import os
import argparse


#command-line interface setting
parser = argparse.ArgumentParser(description = 'Change template file to new file')
parser.add_argument('-i', type = str, help = 'Input of random# directory filename, such as /share/fg3/lintao/random')

args = parser.parse_args()


if __name__ == "__main__":

	name = args.i
	first_list = re.split('/', name)
	second_list = re.sub(r'/', '\/', name)
	cmd1 = 'cat fitting_3D_template_one_split_admix_1_to_3_mig.py | sed "s/xxxxfs/' + second_list + '\/three_pop.fs/" > run_' + first_list[-1] + '_three_pop.py'
	#print(cmd)
	print ('/home/mudesheng/bin/python2.7 ' + 'run_' + first_list[-1] + '_three_pop.py >>' + first_list[-1] + '_3D.result')
	os.system(cmd1)
	print ('rm ' + 'run_' + first_list[-1] + '_three_pop.py')
