#!/usr/local/bin/python3
# program name: introgression analysis
###program information###
# verison: 1.0 anthor zhuguangtao	date:2013.9.26
#include the required module
import os
import sys
import argparse

# commamd-line interface setting

parser = argparse.ArgumentParser(description='find the snp same with TS-403')
parser.add_argument('-input', type = argparse.FileType('r'), help ='input the genotype file')
parser.add_argument('-num', type = int ,help ='the individul.txt row number ')
parser.add_argument('-output',type= argparse.FileType('w'), help = 'output the result')

args=parser.parse_args()

#class difination 
def analysis_for_tm(f1, m, f2):
	n = m+1
	list_p=['A','T','C','G']
	dict_j={'R':['A','G'],'W':['A','T'],'Y':['T','C'],'K':['G','T'],'M':['A','C'],'S':['G','C']}
	for eachline in f1:
		eachline_sp= eachline.strip().split()
		if eachline_sp[66] in list_p and eachline_sp[n] in list_p:  # eachline_sp[66] is the TS-403 position in snp dataset
			if eachline_sp[n] == eachline_sp[66] :  
				f2.write('%s\t%s\t+\n'%(eachline_sp[0],eachline_sp[1]))
			if eachline_sp[n] != eachline_sp[66]: 
				f2.write('%s\t%s\t-\n'%(eachline_sp[0],eachline_sp[1]))
		if eachline_sp[66] in list_p and eachline_sp[n] in dict_j:
			if eachline_sp[66] in dict_j[eachline_sp[n]] :
				f2.write('%s\t%s\t+\n'%(eachline_sp[0],eachline_sp[1]))
			if eachline_sp[66] not in dict_j[eachline_sp[n]]:
				f2.write('%s\t%s\t-\n'%(eachline_sp[0],eachline_sp[1]))
			
			
		if eachline_sp[66] in dict_j: 
			if  eachline_sp[n] in dict_j[eachline_sp[66]] : 
				f2.write('%s\t%s\t+\n'%(eachline_sp[0],eachline_sp[1]))
			if eachline_sp[n] not in dict_j[eachline_sp[66]] and eachline_sp[n]!= '-':
				f2.write('%s\t%s\t-\n'%(eachline_sp[0],eachline_sp[1]))
			if  eachline_sp[n] == eachline_sp[66]:
				f2.write('%s\t%s\t+\n'%(eachline_sp[0],eachline_sp[1]))
			if  eachline_sp[n] != eachline_sp[66]:
				f2.write('%s\t%s\t-\n'%(eachline_sp[0],eachline_sp[1]))
			

if __name__ == "__main__":
	analysis_for_tm(args.input, args.num, args.output)
	args.input.close()
	args.output.close()

