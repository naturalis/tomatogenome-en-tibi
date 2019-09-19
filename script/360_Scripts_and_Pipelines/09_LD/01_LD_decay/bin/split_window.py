#!/usr/local/bin/python3
#Program name: filter_mis_maf.py
###Program information###
#	version: 1.0				author: lintao <lintao19870305@gmail.com>		date: 2014-08-10
"""
				module description
								version: 1.0 author: lintao <lintao19870305@gmail.com>		date: 2014-09-10
"""

#include the required module
import sys
import re
import os
import argparse


#command-line interface setting
parser = argparse.ArgumentParser(description = 'Screening difference SNP-line to New file')
parser.add_argument('-i', type = argparse.FileType('r'), help = 'Input of each population file')
parser.add_argument('-win', type = int, help = 'Input of windown size')
parser.add_argument('-chr', type = int, help = 'Input of chromosome number')
parser.add_argument('-len', type = argparse.FileType('r'), help = 'Input of chromosome length file')
parser.add_argument('-o', type = str, help = 'Name of output file')

args = parser.parse_args()


#global varialbe
debug = True


#class definition


#function definition
def ScreenSNP(input, window, chr, chr_length, output):			#I filter ',' in the column of ALT, zhou don't filter it.

#	if '/' in output:
#		output = output.split('/')[-1]

	length_list = []
	first_list = []
	second_list = []
	
	for eachline in chr_length:		#chromosome length
		eachline = eachline.strip()
		first_list = eachline.split('\t')
		length_list.append(first_list[1])
		
	
	output_list = []
	
	for i in range(0, int(length_list[chr])//1000000+1):
		output_list.append(output+'_'+str(i*1000000))


	for eachline in input:		#genotype file
		eachline = eachline.strip()
		if eachline[0] == '#':
			continue
		first_list = eachline.split('\t')
		num_window = int(first_list[1]) // window
		out_file = open(output_list[num_window], 'a')		#pay attention to append
		out_file.write(eachline+'\n')
		out_file.close()


if __name__ == "__main__":

	ScreenSNP(args.i, args.win, args.chr, args.len, args.o)
	args.i.close()
