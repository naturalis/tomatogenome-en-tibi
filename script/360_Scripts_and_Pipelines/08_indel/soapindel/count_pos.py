#!/usr/local/bin/python3
#Program name: count_pos.py
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
		if first_list[2] == 'exon':
			for i in range(int(first_list[3]), int(first_list[4])):
				dict_pos[first_list[0]+'_'+str(i)] = 'exon'
		elif first_list[2] == 'intron':
			for i in range(int(first_list[3]), int(first_list[4])):
				dict_pos[first_list[0]+'_'+str(i)] = 'intron'
		elif 'five_prime_UTR' in first_list[2]:
			for i in range(int(first_list[3]), int(first_list[4])):
				dict_pos[first_list[0]+'_'+str(i)] = 'five_prime_UTR'
		elif 'three_prime_UTR' in first_list[2]:
			for i in range(int(first_list[3]), int(first_list[4])):
				dict_pos[first_list[0]+'_'+str(i)] = 'three_prime_UTR'
	
	for eachline in input2:		# length file
		eachline = eachline.strip()
		if eachline[0] == '#' or not eachline:
			continue
		first_list = eachline.split('\t')
		if (first_list[0]+'_'+first_list[1]) in dict_pos:
			output.write('{0}\t{1}\n'.format(eachline, dict_pos[first_list[0]+'_'+first_list[1]]))
		else:
			output.write('{0}\tintergenic\n'.format(eachline))
		



if __name__ == "__main__":

	ScreenSNP(args.i1, args.i2, args.o)
	args.i1.close()
	args.i2.close()
	args.o.close()

