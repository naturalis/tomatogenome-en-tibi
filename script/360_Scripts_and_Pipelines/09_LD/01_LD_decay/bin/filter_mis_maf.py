#!/usr/local/bin/python3
#Program name: filter_mis_maf.py
###Program information###
#	version: 1.0				author: lintao <lintao19870305@gmail.com>		date: 2014-08-09
"""
				module description
								version: 1.0 author: lintao <lintao19870305@gmail.com>		date: 2014-08-09
"""

#include the required module
import sys
import re
import os
import argparse


#command-line interface setting
parser = argparse.ArgumentParser(description = 'Screening difference SNP-line to New file')
parser.add_argument('-i', type = argparse.FileType('r'), help = 'Input of each population file')
parser.add_argument('-r', type = float, help = 'Input of missing cutoff')
parser.add_argument('-maf', type = float, default = 0.05, help = 'Input of maf cutoff')
parser.add_argument('-o', default = 'parser.out', type = argparse.FileType('w'), help = 'output of New file')

args = parser.parse_args()


#global varialbe
debug = True


#class definition


#function definition
def ScreenSNP(input, ratio, maf, output):			#I filter ',' in the column of ALT, zhou don't filter it.

	first_list = []
	second_list = []
	count_maf_list = []
	count_maf_set = set()

	abnormal_list = ['N', 'U', 'B', 'D', 'H', 'V']
	dict_allele = {}
	dict_allele = {'A':'AA', 'G':'GG', 'T':'TT', 'C':'CC', 'K':'GT', 'S':'GC', 'Y':'TC', 'M':'AC', 'W':'AT', 'R':'GA'}

	for eachline in input:		#genotype file
		eachline = eachline.strip()
		if eachline[0] == '#':
			continue
		first_list = eachline.split('\t')
		second_list = re.split(' ', first_list[2])
		mis_nu = second_list.count('-')
		mis_ratio = float(mis_nu)/float(len(second_list))         #count missing data
		if mis_ratio <= ratio:
			for i in range(0, len(abnormal_list)):
				if abnormal_list[i] in second_list:
					break
			if i != len(abnormal_list)-1:
				continue
			else:
				for j in range(0, len(second_list)):
					if second_list[j] in dict_allele:
						count_maf_list.append(dict_allele[second_list[j]][0])
						count_maf_list.append(dict_allele[second_list[j]][1])
						count_maf_set.add(dict_allele[second_list[j]][0])
						count_maf_set.add(dict_allele[second_list[j]][1])
				if len(count_maf_set) == 2:
					allele1_maf = count_maf_list.count(str(count_maf_set)[2])
					allele2_maf = count_maf_list.count(str(count_maf_set)[7])
					allele1_ratio = float(allele1_maf) / (float(allele1_maf) + float(allele2_maf))
					allele2_ratio = float(allele2_maf) / (float(allele1_maf) + float(allele2_maf))	
					if allele1_ratio >= maf and allele2_ratio >= maf:
						output.write('{0}\n'.format(eachline))
				count_maf_set = set()
				count_maf_list = []


if __name__ == "__main__":

	ScreenSNP(args.i, args.r, args.maf, args.o)
	args.i.close()
	args.o.close()

