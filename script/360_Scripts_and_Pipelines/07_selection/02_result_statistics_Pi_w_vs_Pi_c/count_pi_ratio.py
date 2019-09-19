import sys
import os
import re

with open('../all.poly', 'r') as file:
	with open('all_ratio.poly', 'w') as output:
		for eachline in file:
			eachline = eachline.strip()
			first_list = eachline.split()
			ratio = float(first_list[5]) / float(first_list[2])
			output.write('{0}\t{1}\n'.format(eachline, ratio))

