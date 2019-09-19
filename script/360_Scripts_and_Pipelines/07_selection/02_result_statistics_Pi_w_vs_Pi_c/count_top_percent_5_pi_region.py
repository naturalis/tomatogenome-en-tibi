import sys
import os

flag = 0
first_list = []
number = 1

with open('top_5_chr_pos_sort_filter.poly', 'r') as file:
	with open('sweep_regions.txt', 'w') as output:
		output.write('#Chromsome\tStart\tEnd\tLength(bp)\tpi_ceris\tpi_pimp\tpi_pimpvsceris\ttajima\'D_ceris\ttajima\'D_pimp\n')
		for eachline in file:
			eachline = eachline.strip()
			first_list = eachline.split()
			if flag == 0:
				form_chr_ID = first_list[0]
				start_pos = int(first_list[1])		#the start of sweeps regions
				form_chr_pos = int(first_list[1])		#the former postion
				form_chr_pi_ceris = float(first_list[2])	#the former ceris' pi
				form_chr_tajima_ceris = float(first_list[4])    #the former ceris' tajima'D
				form_chr_pi_pimp = float(first_list[5])		#the former pimp's pi
				form_chr_tajima_pimp = float(first_list[7])	#the former pimp's tajima'D
				form_chr_pi_cerisvspimp = float(first_list[9])		#the former vs pi
				flag = 1
			elif flag == 1:
				if first_list[0] == form_chr_ID:
					#if (int(first_list[1]) - (int(form_chr_pos)+100000)) <= 200000:		#less than 200k between two regions
					if (int(first_list[1]) - (int(form_chr_pos)+100000)) <= 100000:
						form_chr_pi_ceris += float(first_list[2])
						form_chr_tajima_ceris += float(first_list[4])
						form_chr_pi_pimp += float(first_list[5])
						form_chr_tajima_pimp += float(first_list[7])
						form_chr_pi_cerisvspimp += float(first_list[9])
						number += 1
#						form_chr_pi_ceris = (form_chr_pi_ceris + float(first_list[2])) / 2
#						form_chr_pi_pimp = (form_chr_pi_pimp + float(first_list[5])) / 2
#						form_chr_pi_cerisvspimp = (form_chr_pi_cerisvspimp + float(first_list[9])) / 2
						form_chr_pos = int(first_list[1])
					else:
						output.write('{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}\n'.format(form_chr_ID, start_pos, form_chr_pos + 100000, form_chr_pos - start_pos + 100000, form_chr_pi_ceris/(number*100000), form_chr_pi_pimp/(number*100000), form_chr_pi_pimp/form_chr_pi_ceris, form_chr_tajima_ceris/number, form_chr_tajima_pimp/number))
						number = 1
						form_chr_ID = first_list[0]
						start_pos = int(first_list[1])      #the start of sweeps regions
						form_chr_pos = int(first_list[1])       #the former postion
						form_chr_pi_ceris = float(first_list[2])    #the former ceris' pi
						form_chr_tajima_ceris = float(first_list[4])    #the former ceris' tajima'D
						form_chr_pi_pimp = float(first_list[5])     #the former pimp's pi
						form_chr_tajima_pimp = float(first_list[7]) #the former pimp's tajima'D
						form_chr_pi_cerisvspimp = float(first_list[9])      #the former vs pi
				else:
					output.write('{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}\n'.format(form_chr_ID, start_pos, form_chr_pos + 100000, form_chr_pos - start_pos + 100000, form_chr_pi_ceris/(number*100000), form_chr_pi_pimp/(number*100000), form_chr_pi_pimp/form_chr_pi_ceris, form_chr_tajima_ceris/number, form_chr_tajima_pimp/number))
					number = 1
					form_chr_ID = first_list[0]
					start_pos = int(first_list[1])      #the start of sweeps regions
					form_chr_pos = int(first_list[1])       #the former postion
					form_chr_pi_ceris = float(first_list[2])    #the former ceris' pi
					form_chr_tajima_ceris = float(first_list[4])    #the former ceris' tajima'D
					form_chr_pi_pimp = float(first_list[5])     #the former pimp's pi
					form_chr_tajima_pimp = float(first_list[7]) #the former pimp's tajima'D
					form_chr_pi_cerisvspimp = float(first_list[9])      #the former vs pi
		output.write('{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}\n'.format(form_chr_ID, start_pos, form_chr_pos + 100000, form_chr_pos - start_pos + 100000, form_chr_pi_ceris/(number*100000), form_chr_pi_pimp/(number*100000), form_chr_pi_pimp/form_chr_pi_ceris, form_chr_tajima_ceris/number, form_chr_tajima_pimp/number))


