import pathlib
pwd = "C:/Users/HP 8460p/Documents/Biology master/En tibi internship/Data/"

infolder = "snpfiles_new/"
outfolder = "snpfiles_new_pruned/"
accessions_file = str(pwd) + "accessions_new.tsv"
ref_sites = {}
ref_alleles = {}
ref_id = 0
snp_id = 0

# make accession mapping
    # read in 'accessions_cleaned.tsv'
    # loop over entries
    # Filter out any snps which are located at chromosome 0
    # write cleaned entries into new folder.

with open(accessions_file) as f:
    accessions = f.readlines()

for i in range(1,len(accessions)):
    print(i)
    acc = accessions[i]
    acc = acc.split()[:2]
    # acc[0] is accessions id, acc[1] is label (and filename of snps files.)

    # Filenames have "-" instead of "."
    snps_file = pwd + infolder + acc[1].replace(".", "-") + ".csv"
    # start reading the snps file
    outfile = pwd + outfolder + acc[1].replace(".", "-") + ".csv"
    with open(snps_file) as f:
        snps = f.readlines()
    with open(outfile, 'w') as f_out:
        for line in snps:
            chromosome = line.split(",")[0]
            if len(chromosome) == 0:
                #print("This is chromosome"+ chromosome)
                continue
            f_out.write(line)

