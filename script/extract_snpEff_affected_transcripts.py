path ="C:\\Users\\HP 8460p\\Documents\\Biology master\\En tibi internship\\Data\\snpEff\\"

out = "Gene_Info_Moderate_Impact_TS_153_unique.txt"
file = "TS.153.unique.ann.vcf"
search_term = 'MODERATE'

with open(path+out, 'w') as f_out:
    with open(path+file) as f_in:
        lines = f_in.readlines()
    # lines were selected using grep to include only lines with effects labeled 'HIGH' or 'MODERATE'.
    # The format is a tsv style file, however the information that I am trying to extract is all in the 8th column.
        for line in lines:
            if line[0] == '#':
                continue
            line = line.split('\t')
            ann = line[7]
            # The information written by snpEff is separated using '|'
            ann = ann.split('|')

            # Multiple effects might be listed on a single line.
            # Workaround: Look for instances of "HIGH" or "MODERATE" and store the relevant fields surrounding that instance
            for i in range(len(ann)):
                if ann[i] == search_term:
                    eff = ann[i-1]
                    gene_id = ann[i+1]
                    transcript_id = ann[i+4]
                    # transcript id starts with "mRNA:" which is not required. only keep characters 5 and onwards
                    transcript_id = transcript_id[5:]
                    print(transcript_id)
                    effect_info = [eff, gene_id, transcript_id]
                    effect_info = "\t".join(effect_info) + "\n"
                    f_out.write(effect_info)
