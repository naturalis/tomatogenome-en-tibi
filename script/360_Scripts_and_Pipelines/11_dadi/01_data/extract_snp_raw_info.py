#!/usr/local/bin/python3
##Program name:	extract_snp_raw_info.py
###Program information###
#	version: 1.0			author: lintao <lintao19870305@gmail.com>		date: 2013-11-05
"""
				module description
								version: 1.0 author: lintao		<lintao19870305@gmail.com>		date: 2013-11-05
"""

#include the required module
import sys
import re
import os
import argparse


#command-line interface setting
parser = argparse.ArgumentParser(description = 'mean_confidence_interval')
parser.add_argument('-i1', type = argparse.FileType('r'), help = 'Input of snp file')
parser.add_argument('-i2', type = argparse.FileType('r'), help = 'Input of raw file')
parser.add_argument('-o', type = argparse.FileType('w'), help = 'output of New file')

args = parser.parse_args()


#global variable
debug = True


#class definition


#function definition
def extract_snp_raw_info(input1, input2, output):
	
	first_list = []
	dict = {}

	for eachline in input1:		#snp file
		eachline = eachline.strip()
		first_list = eachline.split('\t')
		dict[first_list[0]+'_'+first_list[1]] = 0

	for eachline in input2:		#raw file
		eachline = eachline.strip()
		first_list = eachline.split('\t')
		if (first_list[0]+'_'+first_list[1]) in dict:
			output.write('{0}\n'.format(eachline))	
	
		
	
if __name__ == "__main__":
	
	extract_snp_raw_info(args.i1, args.i2, args.o)
	args.i1.close()
	args.i2.close()
	args.o.close()
