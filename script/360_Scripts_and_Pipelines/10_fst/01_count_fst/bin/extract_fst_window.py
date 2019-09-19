#!/usr/local/bin/python3
#program name: extract_fst_window.py
##program information###
#  version: 1.0			author: lintao <lintao19870305@gmail.com>	date: 2013-11-07
"""
		module description
				version: 1.0 author: lintao <lintao19870305@gmail.com>   date: 2013-11-07
"""

#include the required module
import sys
import os
import re
import argparse

#command-line interface setting
parser = argparse.ArgumentParser(description = 'Screening Fst from window')
parser.add_argument('-chr', type = str, help = 'Chromosome Number (Fst window file, such as Chr1)')
parser.add_argument('-o', type = argparse.FileType('w'), help = 'Output of Fst result file')

args = parser.parse_args()



#global variable
debug = True


#class definition


#function definition

def Extractfst(chr, output):
	
	input = open(chr+'.fst.overall', 'r')
	
	dict = {}
	dict = {'ch01':'ch01', 'ch02':'ch02', 'ch03':'ch03', 'ch04':'ch04', 'ch05':'ch05', 'ch06':'ch06',  'ch07':'ch07', 'ch08':'ch08', 'ch09':'ch09', 'ch10':'ch10', 'ch11':'ch11', 'ch12':'ch12'}
	first_list = []
	
	for eachline in input:			#Fst window file
		eachline = eachline.strip()
		if not eachline:			#null line
			continue
		if eachline[0] != "\"":		# window start
			output.write('{0}\t{1}\t'.format(dict[chr], eachline))
		else:
			if '"Fst"' in eachline:
				first_list = eachline.split(' ')
				output.write('{0}\n'.format(first_list[1]))
	
	input.close()


if __name__ == "__main__":
	Extractfst(args.chr, args.o)
	args.o.close()







