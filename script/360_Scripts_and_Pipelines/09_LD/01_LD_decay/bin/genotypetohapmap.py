#!/usr/local/bin/python3
#program name: genotypetohapmap.py
###program information###
#  version: 1.0			author: lintao <lintao19870305@gmail.com>	date:2012-03-24
"""
		module description
				version: 1.0 author: lintao <lintao19870305@gmail.com>   date:2012-03-24
"""

#include the required module
import os
import sys 
import re
import argparse

#command-line interface setting
parser = argparse.ArgumentParser(description='format transition')
parser.add_argument('-i1', type = argparse.FileType('r'), help='input of SNP file')
parser.add_argument('-i2', type = argparse.FileType('r'), help='input of individual information file')
parser.add_argument('-o', type = argparse.FileType('w'), help='output of result file')
parser.add_argument('-left', type = int, default = 0, help='a left integer')
parser.add_argument('-right', type = int, default = 100000000000, help='a right integer')
parser.add_argument('-chr', type = str, default = 'ALL', help='Chromosome name (ALL)')

args = parser.parse_args()

#global variable
debug = True



#class definition
def Transposition(input1, input2, output, chr, left, right):
	
	output.write('rs# alleles chrom pos strand assembly# center protLSID assqyLSID panelLSID QCcode')
	for eachline in input2:
		eachline = eachline.strip()
		ID_list = eachline.split('\t')
		output.write(' S{0}'.format(ID_list[0]))	#individual ID is the same with structure and phenotype
	output.write('\n')
	
	first_list = []
	genotype_set = set()
	genotype_list = []
	line_number = 1
	
	for eachline in input1:
		eachline = eachline.strip()
		first_list = eachline.split('\t')
		if 'N' in first_list[2] or 'B' in first_list[2] or 'D' in first_list[2] or 'H' in first_list[2] or 'V' in first_list[2]:
			continue
		second_list = re.split(' ', first_list[2])
		if first_list[0] == chr:
			if left <= int(first_list[1]) <= right:
				for i in range(0, len(second_list)):
					if second_list[i] == 'A':
						genotype_set.add('A')
					elif second_list[i] == 'C':
						genotype_set.add('C')
					elif second_list[i] == 'G':
						genotype_set.add('G')
					elif second_list[i] == 'T':
						genotype_set.add('T')
					elif second_list[i] == 'W':
						genotype_set.add('T')
						genotype_set.add('A')
					elif second_list[i] == 'R':
						genotype_set.add('A')
						genotype_set.add('G')
					elif second_list[i] == 'M':
						genotype_set.add('C')
						genotype_set.add('A')
					elif second_list[i] == 'Y':
						genotype_set.add('C')
						genotype_set.add('T')
					elif second_list[i] == 'S':
						genotype_set.add('G')
						genotype_set.add('C')
					elif second_list[i] == 'K':
						genotype_set.add('T')
						genotype_set.add('G')
				if len(genotype_set) == 2:
					output.write('SNP{0} '.format(line_number))
					line_number += 1
					genotype_list = list(genotype_set)
					output.write('{0}/{1} '.format(genotype_list[0], genotype_list[1]))
					output.write('{0} {1} + NA NA NA NA NA NA'.format(first_list[0], first_list[1]))	# Please being careful for first_list[0][-2] is chromosome ID
					for i in range(0, len(second_list)):
						if second_list[i] == '-':
							output.write(' NN')
						elif second_list[i] == 'A':
							output.write(' AA')
						elif second_list[i] == 'T':
							output.write(' TT')
						elif second_list[i] == 'C':
							output.write(' CC')
						elif second_list[i] == 'G':
							output.write(' GG')
						elif second_list[i] == 'R':
							output.write(' GA')
						elif second_list[i] == 'W':
							output.write(' TA')
						elif second_list[i] == 'M':
							output.write(' CA')
						elif second_list[i] == 'Y':
							output.write(' TC')
						elif second_list[i] == 'S':
							output.write(' GC')
						elif second_list[i] == 'K':
							output.write(' GT')
				else:
					genotype_set = set()
					continue
				genotype_set = set()
				output.write('\n')
		elif chr == 'ALL':
			for i in range(0, len(second_list)):
				if second_list[i] == 'A':
					genotype_set.add('A')
				elif second_list[i] == 'C':
					genotype_set.add('C')
				elif second_list[i] == 'G':
					genotype_set.add('G')
				elif second_list[i] == 'T':
					genotype_set.add('T')
				elif second_list[i] == 'W':
					genotype_set.add('T')
					genotype_set.add('A')
				elif second_list[i] == 'R':
					genotype_set.add('A')
					genotype_set.add('G')
				elif second_list[i] == 'M':
					genotype_set.add('C')
					genotype_set.add('A')
				elif second_list[i] == 'Y':
					genotype_set.add('C')
					genotype_set.add('T')
				elif second_list[i] == 'S':
					genotype_set.add('G')
					genotype_set.add('C')
				elif second_list[i] == 'K':
					genotype_set.add('T')
					genotype_set.add('G')
			if len(genotype_set) == 2:
				output.write('SNP{0} '.format(line_number))
				line_number += 1
				genotype_list = list(genotype_set)
				output.write('{0}/{1} '.format(genotype_list[0], genotype_list[1]))
				output.write('{0} {1} + NA NA NA NA NA NA'.format(first_list[0], first_list[1]))	# Please being careful for first_list[0][-2] is chromosome ID
				for i in range(0, len(second_list)):
					if second_list[i] == '-':
						output.write(' NN')
					elif second_list[i] == 'A':
						output.write(' AA')
					elif second_list[i] == 'T':
						output.write(' TT')
					elif second_list[i] == 'C':
						output.write(' CC')
					elif second_list[i] == 'G':
						output.write(' GG')
					elif second_list[i] == 'R':
						output.write(' GA')
					elif second_list[i] == 'W':
						output.write(' TA')
					elif second_list[i] == 'M':
						output.write(' CA')
					elif second_list[i] == 'Y':
						output.write(' TC')
					elif second_list[i] == 'S':
						output.write(' GC')
					elif second_list[i] == 'K':
						output.write(' GT')
			else:
				genotype_set = set()
				continue
			genotype_set = set()
			output.write('\n')
			
		

if __name__ == "__main__":
	Transposition(args.i1, args.i2, args.o, args.chr, args.left, args.right)
	args.i1.close()
	args.i2.close()
	args.o.close()

