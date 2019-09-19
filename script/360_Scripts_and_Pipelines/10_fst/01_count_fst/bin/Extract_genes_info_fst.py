#!/usr/local/bin/python3
#program name: Extract_genes_info.py
###program information###
#  version: 1.0			author: lintao <lintao19870305@gmail.com>	date: 2013-10-05
"""
		module description
				version: 1.0 author: lintao <lintao19870305@gmail.com>   date: 2013-10-05
"""

#include the required module
import sys
import os
import re
import argparse

#command-line interface setting
parser = argparse.ArgumentParser(description = 'Extract genesinformation from sweep region')
parser.add_argument('-i1', type = argparse.FileType('r'), help = 'Gene annotation file')
parser.add_argument('-i2', type = argparse.FileType('r'), help = 'Sweep region information file')
parser.add_argument('-o', type = argparse.FileType('w'), help = 'Output of results file')

args = parser.parse_args()



#global variable
debug = True


#class definition


#function definition

def Extract_genes_info(input1, input2, output):
	
	
	first_list = []
	i = 1
	dict = {}
	
	for eachline in input2:
		eachline = eachline.strip()
		if eachline[0] == '#':
			continue
		first_list = eachline.split('\t')
		dict['DS' + str(i) + first_list[0]] = []
		dict['DS' + str(i) + first_list[0]].append(int(first_list[1]))
		dict['DS' + str(i) + first_list[0]].append(int(first_list[2]))
		i += 1
	
	
	for eachline in input1:			#chromosome file
		eachline = eachline.strip()
		if not eachline or eachline[0] == '#':			#null line
			continue
		second_list = eachline.split('\t')
		if second_list[2] == 'mRNA':
			m = re.match('^ID=mRNA:(.*);Name', second_list[8])
			n = re.match('.*Note=(.*);P', second_list[8])
			for i in range(0, len(dict)):
				if ('DS' + str(i) + second_list[0][6:]) in dict:
					if dict['DS' + str(i) + second_list[0][6:]][0] <= int(second_list[3]) <= dict['DS' + str(i) + second_list[0][6:]][1] or dict['DS' + str(i) + second_list[0][6:]][0] <= int(second_list[4]) <= dict['DS' + str(i) + second_list[0][6:]][1]:
						output.write('{0}\t{1}\t{2}\t{3}\t{4}\n'.format(second_list[0][6:], second_list[3], second_list[4], m.group(1), n.group(1)))



if __name__ == "__main__":
	Extract_genes_info(args.i1, args.i2, args.o)
	args.i1.close()
	args.i2.close()
	args.o.close()
