#!/usr/local/bin/python3
#program name: determine_nonsyn_fst_gene.py
##program information###
#  version: 1.0			author: lintao <lintao19870305@gmail.com>	date: 2013-11-08
"""
		module description
				version: 1.0 author: lintao <lintao19870305@gmail.com>   date: 2013-11-08
"""

#include the required module
import sys
import os
import re
import argparse

#command-line interface setting
parser = argparse.ArgumentParser(description = 'Screening Genes')
parser.add_argument('-i1', type = argparse.FileType('r'), help = 'Tomato Nonsynonymous file')
parser.add_argument('-i2', type = argparse.FileType('r'), help = 'Top_5 fst single file')
parser.add_argument('-i3', type = argparse.FileType('r'), help = 'Gff3 file')
parser.add_argument('-o', type = argparse.FileType('w'), help = 'Output of genes result file')

args = parser.parse_args()



#global variable
debug = True


#class definition


#function definition

def Extractgene(input1, input2, input3, output):
	
	first_list = []
	dict = {}
	
	for eachline in input1:		#nonsynonymous file
		eachline = eachline.strip()
		first_list = eachline.split('\t')
		dict[first_list[0]+'_'+first_list[1]] = first_list[6]

	
#	print (dict)

	second_list = []
	dict_gene = {}
	
	for eachline in input2:			#Top_5 Fst single file
		eachline = eachline.strip()
		if not eachline or eachline[0] == 'L':			#null line
			continue
		second_list = eachline.split('\t')
		if (second_list[0]+'_'+second_list[1]) in dict:
			dict_gene[dict[second_list[0]+'_'+second_list[1]]] = 0

	#print(dict_gene)
	third_list = []
	
	for eachline in input3:		# gff3 file
		eachline = eachline.strip()
		if not eachline or eachline[0] == '#':          #null line
			continue
		if 'mRNA' in eachline:
			third_list = eachline.split('\t')
			fourth_list = re.split(';|=', third_list[8])
			fifth_list = re.split(':', fourth_list[1])
			#print(fourth_list)
			#print(fifth_list)
			if fifth_list[1] in dict_gene:
				output.write('{0}\t{1}\t{2}\t{3}\t{4}\t{5}\n'.format(third_list[0], third_list[3], third_list[4], fifth_list[1], fourth_list[5], fourth_list[7]))
	


if __name__ == "__main__":
	Extractgene(args.i1, args.i2, args.i3, args.o)
	args.i1.close()
	args.i2.close()
	args.i3.close()
	args.o.close()







