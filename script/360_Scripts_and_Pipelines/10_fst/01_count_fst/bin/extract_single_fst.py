#!/usr/local/bin/python3
#program name: extract_single_fst.py
##program information###
#  version: 2.0			author: lintao <lintao19870305@gmail.com>	date: 2014-01-05
"""
		module description
				version: 2.0 author: lintao <lintao19870305@gmail.com>   date: 2014-01-05
"""

#include the required module
import sys
import os
import re
import argparse

#command-line interface setting
parser = argparse.ArgumentParser(description = 'Screening Fst from window')
parser.add_argument('-i', type = argparse.FileType('r'), help = 'fst single file')
parser.add_argument('-o', type = argparse.FileType('w'), help = 'Output of single fst result file')

args = parser.parse_args()



#global variable
debug = True


#class definition


#function definition

def Extractfst(input, output):
	
	first_list = []
	list = []
#	dict_gene = {}
	
#	for eachline in input3:		#divergence genes file
#		eachline = eachline.strip()
#		first_list = eachline.split('\t')
#		dict_gene[first_list[3]] = 0
	
	second_list = []
	third_list = []
	
	for eachline in input:			#Fst single file
		eachline = eachline.strip()
		if not eachline or eachline[0] == 'L':			#null line
			continue
		second_list = eachline.split(' ')
		third_list = re.split('\"|\.', second_list[0])
		if second_list[7] != 'NA':
			if third_list[2] not in list:
				list.append(third_list[2])
				output.write('{0}\t{1}\t{2}\n'.format(third_list[1], third_list[2], second_list[7]))
	


if __name__ == "__main__":
	Extractfst(args.i, args.o)
	args.i.close()
	args.o.close()







