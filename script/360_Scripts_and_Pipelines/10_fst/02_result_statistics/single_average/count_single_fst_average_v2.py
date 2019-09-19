#!/usr/local/bin/python3
#program name: count_single_fst_average.py
##program information###
#  version: 1.0			author: lintao <lintao19870305@gmail.com>	date: 2013-12-06
"""
		module description
				version: 1.0 author: lintao <lintao19870305@gmail.com>   date: 2013-12-06
"""

#include the required module
import sys
import os
import re
import argparse

#command-line interface setting
parser = argparse.ArgumentParser(description = 'Screening Genes')
parser.add_argument('-i', type = argparse.FileType('r'), help = 'Tomato Single fst of each chromosome file')
parser.add_argument('-o', type = argparse.FileType('a'), help = 'Output of genes result file')

args = parser.parse_args()



#global variable
debug = True


#class definition


#function definition

def Average(input, output):
	
	first_list = []
	sum = 0
	number = 0
	
	for eachline in input:		#single fst file
		eachline = eachline.strip()
		if 'Fst' in eachline or 'NA' in eachline:
			continue
		if float(eachline) > 0:
			sum += float(eachline)
			number += 1
	
	average = sum / number
	output.write('{0}\n'.format(average))

	


if __name__ == "__main__":
	Average(args.i, args.o)
	args.i.close()
	args.o.close()







