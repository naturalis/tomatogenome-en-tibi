""" Edited by lintao"""

first_set = set()
second_set = set()

with open('Nonsense_mutation.loci', 'r') as file:
	for eachline in file:
		eachline = eachline.strip()
		first_list = eachline.split('\t')
		first_set.add(first_list[6][:-4])	#all nonsynonymous genes
	#	print(first_list[6][:-4])
#		if 'M<-' in first_list[10]:	#start codon changes
#			first_set.add(first_list[6][:-4])
#		elif '->U' in first_list[10]:	#premature stop codons
#			first_set.add(first_list[6][:-4])
#		elif 'U<-' in first_list[10]:	#elongated transcripts
#			first_set.add(first_list[6][:-4])

	print ('nonsense: ', len(first_set))

set_ch00 = set()
set_ch01 = set()
set_ch02 = set()
set_ch03 = set()
set_ch04 = set()
set_ch05 = set()
set_ch06 = set()
set_ch07 = set()
set_ch08 = set()
set_ch09 = set()
set_ch10 = set()
set_ch11 = set()
set_ch12 = set()


with open('tomato_nonSynonymous.info', 'r') as file:
	for eachline in file:
		eachline = eachline.strip()
		first_list = eachline.split('\t')
		second_set.add(first_list[6][:-4])  #all nonsynonymous genes
		if first_list[0] == 'ch00':
			set_ch00.add(first_list[6][:-4])
		elif first_list[0] == 'ch01':
			set_ch01.add(first_list[6][:-4])
		elif first_list[0] == 'ch02':
			set_ch02.add(first_list[6][:-4])
		elif first_list[0] == 'ch03':
			set_ch03.add(first_list[6][:-4])
		elif first_list[0] == 'ch04':
			set_ch04.add(first_list[6][:-4])
		elif first_list[0] == 'ch05':
			set_ch05.add(first_list[6][:-4])
		elif first_list[0] == 'ch06':
			set_ch06.add(first_list[6][:-4])
		elif first_list[0] == 'ch07':
			set_ch07.add(first_list[6][:-4])
		elif first_list[0] == 'ch08':
			set_ch08.add(first_list[6][:-4])
		elif first_list[0] == 'ch09':
			set_ch09.add(first_list[6][:-4])
		elif first_list[0] == 'ch10':
			set_ch10.add(first_list[6][:-4])
		elif first_list[0] == 'ch11':
			set_ch11.add(first_list[6][:-4])
		elif first_list[0] == 'ch12':
			set_ch12.add(first_list[6][:-4])
	

	print('Non-syn: ', len(second_set))
	print('ch00: ', len(set_ch00))
	print('ch01: ', len(set_ch01))
	print('ch02: ', len(set_ch02))
	print('ch03: ', len(set_ch03))
	print('ch04: ', len(set_ch04))
	print('ch05: ', len(set_ch05))
	print('ch06: ', len(set_ch06))
	print('ch07: ', len(set_ch07))
	print('ch08: ', len(set_ch08))
	print('ch09: ', len(set_ch09))
	print('ch10: ', len(set_ch10))
	print('ch11: ', len(set_ch11))
	print('ch12: ', len(set_ch12))
