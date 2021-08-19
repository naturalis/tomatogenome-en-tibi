import pathlib
pwd = "C:/Users/HP 8460p/Documents/Biology master/En tibi internship/Data/"

snpfile_dir = "snpfiles_remapped/"
ref_file = pwd + "refsites_remapped.csv"
output_file = pwd + "snps_remapped.csv"
accessions_file = str(pwd) + "accessions_new.tsv"
ref_sites = {}
ref_id = 0
snp_id = 0

# make accession mapping
    # read in 'accessions_cleaned.tsv'
    #loop over entries
    #store accession id (accession primary key) and open pwd/'label'.csv

with open(accessions_file) as f:
    accessions = f.readlines()
with open(output_file, 'w') as f_out:
    for i in range(1,len(accessions)):
        print(i)
        acc = accessions[i]
        acc = acc.split()[:2]
        # acc[0] is accessions pk (accessions fk in snps), acc[1] is label (and filename of snps files.)

        # Filenames have "-" instead of "."
        snps_file = pwd + snpfile_dir + acc[1].replace(".", "-") + ".csv"
        # start reading the snps file
        with open(snps_file) as f:
            snps = f.readlines()
        for line in snps:
            snp_id += 1 # This is a new SNP by definition
            snp = line.split(",")   # get chrom, pos, allele, accession label
            if len(snp[0]) == 0:
                snp[0] = "0"
            site = ",".join(snp[:2])    # useful to check ref_sites


            # add to the ref_sites if we haven't seen this yet
            if site not in ref_sites:
                ref_id += 1
                ref_sites[site] = str(ref_id)

            # add SNP to snps
            # pk, refsite fk, accession fk, allele
            #snp_entry = ",".join([str(snp_id), ref_sites[site], acc[0], snp[2]]) + "\n"
            snp_entry = ",".join([str(snp_id), ref_sites[site], acc[0], '1']) + "\n"
            f_out.write(snp_entry)
# write refsites.csv
# refsite pk, chr, pos
with open(ref_file, 'w') as f:
    for site in ref_sites:
        ref_site_entry = ",".join([ref_sites[site], site]) + "\n"
        f.write(ref_site_entry)

