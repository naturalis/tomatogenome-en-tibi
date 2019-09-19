#!/usr/local/bin/python3
#program name: extract_nonsy_fst.py
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
parser.add_argument('-i1', type = argparse.FileType('r'), help = 'Nonsynonymous file')
parser.add_argument('-i2', type = argparse.FileType('r'), help = 'fst single file')
parser.add_argument('-o', type = argparse.FileType('w'), help = 'Output of nonsyn fst result file')

args = parser.parse_args()



#global variable
debug = True


#class definition


#function definition

def Extractfst(input1, input2, output):
	
	first_list = []
#	dict_gene = {}
	
#	for eachline in input3:		#divergence genes file
#		eachline = eachline.strip()
#		first_list = eachline.split('\t')
#		dict_gene[first_list[3]] = 0
	
		
	dict = {}
	
	for eachline in input1:		#nonsynonymous file
		eachline = eachline.strip()
		first_list = eachline.split('\t')
#		if first_list[6] in dict_gene:
		dict[first_list[0]+'_'+first_list[1]] = 0

	
#	print (dict)

	second_list = []
	third_list = []
	
	for eachline in input2:			#Fst single file
		eachline = eachline.strip()
		if not eachline or eachline[0] == 'L':			#null line
			continue
		second_list = eachline.split(' ')
		third_list = re.split('\"|\.', second_list[0])
		if (third_list[1]+'_'+third_list[2]) in dict:
#			print(third_list[1]+'_'+third_list[2])
			del dict[third_list[1]+'_'+third_list[2]]
			if second_list[7] != 'NA':
				output.write('{0}\t{1}\t{2}\n'.format(third_list[1], third_list[2], second_list[7]))
	


if __name__ == "__main__":
	Extractfst(args.i1, args.i2, args.o)
	args.i1.close()
	args.i2.close()
	args.o.close()







