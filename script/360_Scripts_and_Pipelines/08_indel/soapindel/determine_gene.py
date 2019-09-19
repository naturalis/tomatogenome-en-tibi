#!/usr/local/bin/python3
#Program name: determine_gene.py
###Program information###
#	version: 1.0				author: lintao <lintao19870305@gmail.com>		date: 2014-08-11
"""
				module description
								version: 1.0 author: lintao <lintao19870305@gmail.com>		date: 2014-08-11
"""

#include the required module
import sys
import re
import os
import argparse


#command-line interface setting
parser = argparse.ArgumentParser(description = 'Counting indel\'s position to New file')
parser.add_argument('-i1', type = argparse.FileType('r'), help = 'Input of gff3 file')
parser.add_argument('-i2', type = argparse.FileType('r'), help = 'Input of indel file')
parser.add_argument('-o', default = 'parser.out', type = argparse.FileType('w'), help = 'output of New file')

args = parser.parse_args()


#global varialbe
debug = True


#class definition


#function definition
def ScreenSNP(input1, input2, output):

	first_list = []
	dict_pos = {}
	
	for eachline in input1:		# gff3 file
		eachline = eachline.strip()
		if eachline[0] == '#' or not eachline:
			continue
		first_list = eachline.split('\t')
		if first_list[2] == 'CDS':
			for i in range(int(first_list[3]), int(first_list[4])+1):
				dict_pos[first_list[0]+'_'+str(i)] = first_list[8]
	
	gene_add = set()
	gene_add_frame = set()
	
	for eachline in input2:		# length file
		eachline = eachline.strip()
		if eachline[0] == '#' or not eachline:
			continue
		first_list = eachline.split('\t')
		if (first_list[0]+'_'+first_list[1]) in dict_pos:
			gene_add.add(dict_pos[first_list[0]+'_'+first_list[1]])
			if int(first_list[2]) == 3 or int(first_list[2]) == -3:
				gene_add_frame.add(dict_pos[first_list[0]+'_'+first_list[1]])

	output.write('gene_number:\t{0}\ngene_frame_number:\t{1}\n'.format(len(gene_add), len(gene_add_frame)))


if __name__ == "__main__":

	ScreenSNP(args.i1, args.i2, args.o)
	args.i1.close()
	args.i2.close()
	args.o.close()

