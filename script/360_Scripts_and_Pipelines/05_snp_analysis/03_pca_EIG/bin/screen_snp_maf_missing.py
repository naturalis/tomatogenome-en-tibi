#!/usr/local/bin/python3
#Program name: count_missing_data_maf.py
###Program information###
#		version: 1.0						author: lintao <lintao19870305@gmail.com>			date: 2013-09-09


#include the required module
import sys
import re
import os
import argparse


#command-line interface setting
parser = argparse.ArgumentParser(description = 'Screening line to New file', prog = 'Screen the first tree\'s snp program')
parser.add_argument('-i', type = argparse.FileType('r'), help = 'Input of genotype file (add ref)')
parser.add_argument('-o', type = argparse.FileType('w'), help = 'Output of new file')

args = parser.parse_args()


#global variable
debug = True

#class definition


#function definition
def Addsnp(input, output):
	
	first_list = []
	second_list = []
	count_maf_list = []
	count_maf_set = set()
	
	list = ['N', 'U', 'B', 'D', 'H', 'V']
	dict = {}
	dict = {'A':'AA', 'T':'TT', 'G':'GG', 'C':'CC', 'K':'GT', 'S':'GC', 'Y':'TC', 'M':'AC', 'W':'AT', 'R':'GA'}
	
	for eachline in input:
		eachline = eachline.strip()
		first_list = eachline.split('\t')
		second_list = re.split(' ', first_list[3])
		number = second_list.count('-')
		ratio = float(number) / float(len(second_list))		#count missing data
		if ratio <= 0.10:
			for i in range(0, len(list)):
				if list[i] in second_list:
					break
			if i != len(list)-1:
				continue
			else:
				for j in range(0, len(second_list)):
					if second_list[j] in dict:
						count_maf_list.append(dict[second_list[j]][0])
						count_maf_list.append(dict[second_list[j]][1])
						count_maf_set.add(dict[second_list[j]][0])
						count_maf_set.add(dict[second_list[j]][1])
				if len(count_maf_set) == 2:
					MAF_number1 = count_maf_list.count(str(count_maf_set)[2])
					MAF_number2 = count_maf_list.count(str(count_maf_set)[7])
					MAF_ratio1 = float(MAF_number1) / (float(MAF_number1) + float(MAF_number2))
					MAF_ratio2 = float(MAF_number2) / (float(MAF_number1) + float(MAF_number2))
					if MAF_ratio1 > 0.05 and MAF_ratio2 > 0.05:
						output.write('{0}\n'.format(eachline))
				count_maf_set = set()
				count_maf_list = []
			

if __name__ == "__main__":
	Addsnp(args.i, args.o)
	args.i.close()
	args.o.close()
