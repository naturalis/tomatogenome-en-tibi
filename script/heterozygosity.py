pwd = "C:/Users/HP 8460p/Documents/Biology master/En tibi internship/Data/"

in_file = "Structure/structure_table_bases_remapped.str"
out_file = "heterozygosity_table.tsv"
individuals = 115
f_out = open(pwd + out_file, 'w')
f_in = open(pwd + in_file)

# Reading in both sequences from the structure file. The two strands are written on separate lines.
for i in range(individuals):
    strand_1 = f_in.readline()
    strand_1 = strand_1.split('\t')
    strand_2 = f_in.readline()
    strand_2 = strand_2.split('\t')

    # Storing the individual ID and the Botanical variety
    ID  = strand_1[4]
    Bot_variety = strand_1[5]
    Origin = strand_1[1]

    # loop to count heterozygous sites
    heterozygous = 0
    for j in range(6, len(strand_1)):
        if strand_1[j] != strand_2[j]:
            heterozygous = heterozygous + 1
    # Calculating heterozygous/total bases
    total_bases = len(strand_1) - 6
    heterozygosity = heterozygous/total_bases
    # writing data out to file.
    if i == 0:
        line = '\t'.join(['ID', 'Bot_variety', 'Origin', 'heterozygosity'])
        line = line + '\n'
        f_out.write(line)
    line = '\t'.join([ID, Bot_variety, Origin, str(heterozygosity)])
    line = line + '\n'
    f_out.write(line)