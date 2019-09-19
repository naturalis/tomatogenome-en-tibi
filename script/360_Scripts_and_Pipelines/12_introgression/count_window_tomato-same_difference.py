#!/usr/local/bin/python3

# program name: count analysis
###program information###
# verison: 1.0 anthor zhuguangtao       date:2013.9.26
#include the required module

import os
import sys
import argparse

# commamd-line interface setting

parser = argparse.ArgumentParser(description='count  the snp same_difference ratio , 1M windows and a step of 100k')
parser.add_argument('-input', type = argparse.FileType('r'), help ='input the same-differ file')
parser.add_argument('-output',type = argparse.FileType('w'), help = 'output the ratio result')
parser.add_argument('-Chr', type = str, help = 'output the ratio result')

args=parser.parse_args()

def count_window(f1, f2, chr):
	dict_diff={}
	dict_same={}
	list_diff=[]
	list_same=[]
	for i in range(0,910):
		dict_diff[str(i)]=[]
	for i in range(0,910):
		dict_same[str(i)]=[]

	for eachline in f1:
		eachline_sp= eachline.strip().split()
		if eachline_sp[2] == '-':
			list_diff.append(int(eachline_sp[1]))
		if eachline_sp[2] == '+':
			list_same.append(int(eachline_sp[1]))

	for i in range(0,910):
		for item in list_diff:
			if 100000*i < item <= 100000*i +1000000:
				dict_diff[str(i)].append(item)
		for item in list_same:
			if 100000*i < item <= 100000*i +1000000:
				dict_same[str(i)].append(item)
	for i in range(0,910):
		sum = len(dict_diff[str(i)]) + len(dict_same[str(i)])+1
		f2.write('%s\t%s\t%.3f\n'%(chr,i,len(dict_same[str(i)])/sum))

if __name__ == "__main__":
	count_window(args.input, args.output, args.Chr)
	args.input.close()
	args.output.close()
