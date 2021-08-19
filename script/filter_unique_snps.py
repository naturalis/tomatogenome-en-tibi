pwd = "C:/Users/HP 8460p/Documents/Biology master/En tibi internship/Data/snpEff/"
En_Tibi_file = "En.Tibi.mincover10.vcf"
TS_153_file = "TS-153.mincover10.vcf"
output_file = "TS-153.unique.snps.vcf"

# Function to retrieve the coordinates of a snp in the vcf file, along with the specific mutation.
# (Different bases might have a different effect)
def get_SNP(line: str):
    line = line.split("\t")
    # the columns are for chromosome, position, identifier (always absent), reference, altallele
    snp = line[:5]
    snp = "-".join(snp)
    return snp

En_Tibi_snps = []
with open(pwd+En_Tibi_file) as f_in:
    En_Tibi = f_in.readlines()
    for line in En_Tibi:
        En_Tibi_snps.append(get_SNP(line))

with open(pwd+output_file,'w') as f_out:
    with open(pwd+TS_153_file) as f_in:
        TS_153_snps = f_in.readlines()
        for line in TS_153_snps:
            snp = get_SNP(line)
            if snp not in En_Tibi_snps:
                f_out.write(line)
            if snp in En_Tibi_snps:
                print(snp)