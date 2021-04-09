# Pre-processing

## 1. Quality assessment and trimming

<!--
	fastp \
		-i "En-Tibi_trimmed (paired).R1.fastq.gz" \
		-I "En-Tibi_trimmed (paired).R2.fastq.gz" \
		-o paired_R1_fastp.fastq.gz \
		-O paired_R2_fastp.fastq.gz \
		-j fastp.json -h fastp.html --verbose

With the new data, this command has changed to: -->

	fastp \
	        -i "/fileserver/projects/B19015-525/updated/run0220_En-Tibi_S2_L003_R1_001.nophix.fastq.gz" \
        	-I "/fileserver/projects/B19015-525/updated/run0220_En-Tibi_S2_L003_R2_001.nophix.fastq.gz" \
	        -o "untrimmed_paired_R1_fastp.fastq.gz" \
        	-O "untrimmed_paired_R2_fastp.fastq.gz" \
	        -j fastp.json -h fastp.html --verbose

## 2. Illumina adaptor trimming

	cutadapt \
        	-a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
		-A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
        	-o paired_R1_fastp.fastq.gz \
	        -p paired_R2_fastp.fastq.gz \
        	untrimmed_paired_R1_fastp.fastq.gz \
	        untrimmed_paired_R2_fastp.fastq.gz

# Assembly

## 3. Indexing the reference

<!--
	minimap2 \
		-d Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz.mmi \
		-t 4 \
		Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz

On the HPC high-mem node this has become: -->

	minimap2 \
		-d "../reference/Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz.mmi" \
		-t 4 \
		"../reference/Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz"

## 4. Mapping

<!--
	minimap2 \
		-ax sr \
		-a \
		-t 4 \
		Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz \
		paired_R1_fastp.fastq.gz paired_R2_fastp.fastq.gz | samtools view \
		-b -u -F 0x04 --threads 4 -o run0220_paired_En-Tibi_S2_L003.bam -

On the HPC high-mem node this has become: -->

	minimap2 \
		-ax sr \
		-a \
		-t 4 \
		"../reference/Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz" \
		"paired_R1_fastp.fastq.gz" "paired_R2_fastp.fastq.gz" | samtools view \
		-b -u -F 0x04 --threads 4 -o "paired_En-Tibi.bam" -

## 5. Correct mate pairs

<!--
	samtools \
		fixmate -r -m  \
		--threads 4 \
		run0220_paired_En-Tibi_S2_L003.bam \
		run0220_paired_En-Tibi_S2_L003.fixmate.bam

The newly parameterized version of this command (with the updated data) goes like this: -->

    samtools \
        	fixmate -r -m  \
	        --threads 4 \
        	"paired_En-Tibi.bam" \
	        "paired_En-Tibi.fixmate.bam"

## 6. Sort the reads

<!--
	samtools \
		sort -l 0 \
		-m 3G \
		--threads 4 \
		-o run0220_paired_En-Tibi_S2_L003.fixmate.sorted.bam run0220_paired_En-Tibi_S2_L003.fixmate.bam

With the updated data, this command is now: -->

    samtools \
		sort -l 0 \
		-m 3G \
		--threads 4 \
		-o "paired_En-Tibi.fixmate.sorted.bam" "paired_En-Tibi.fixmate.bam"

## 7. Mark duplicates

<!--
	samtools \
		markdup -r \
		--threads 4 \
		run0220_paired_En-Tibi_S2_L003.fixmate.sorted.bam \
		run0220_paired_En-Tibi_S2_L003.fixmate.sorted.markdup.bam

With the updated data, this has become: -->

	samtools \
		markdup -r \
		--threads 4 \
		"paired_En-Tibi.fixmate.sorted.bam" \
		"paired_En-Tibi.fixmate.sorted.markdup.bam"

# SNP calling

## 8. Basic stats

Number of bases with at least 10x coverage:

	export MIN_COVERAGE_DEPTH=10	
	samtools mpileup "paired_En-Tibi.fixmate.sorted.markdup.bam" | awk -v X="${MIN_COVERAGE_DEPTH}" '$4>=X' | wc -l

    #     Answer:   9,888,232
    # Ref length: 823,134,955
    # i.e., about 1% has a coverage of >=10x

## 9. Get all the depths 

Produces a file with the depth at every base:

<!--
	samtools depth -a run0220_paired_En-Tibi_S2_L003.fixmate.sorted.markdup.bam > run0220_paired_En-Tibi_S2_L003.fixmate.sorted.markdup.depth
-->

	samtools depth -a "paired_En-Tibi.fixmate.sorted.markdup.bam" > "paired_En-Tibi.fixmate.sorted.markdup.depth"

## 10. Index the reference

<!--
	samtools faidx Solanum_lycopersicum.SL2.50.dna.toplevel.fa
-->	
	
	samtools faidx ../reference/Solanum_lycopersicum.SL2.50.dna.toplevel.fa

## 11. Do the SNP calling

<!--
	bcftools mpileup \
		-Ou \
		-f ../reference/Solanum_lycopersicum.SL2.50.dna.toplevel.fa \
		run0220_paired_En-Tibi_S2_L003.fixmate.sorted.markdup.bam \
		| bcftools call -Ou -mv \
		| bcftools filter -s LowQual -e '%QUAL<20 || DP>20' \
		> run0220_paired_En-Tibi_S2_L003.fixmate.sorted.markdup.flt.vcf
-->

	bcftools mpileup \
		-Ou \
		-f ../reference/Solanum_lycopersicum.SL2.50.dna.toplevel.fa \
		paired_En-Tibi.fixmate.sorted.markdup.bam \
		| bcftools call -Ou -mv \
		| bcftools filter -s LowQual -e '%QUAL<20 || DP>20' \
		> paired_En-Tibi.fixmate.sorted.markdup.flt.vcf

## Compute the average depths

Command to execute on the file `paired_En-Tibi.fixmate.sorted.markdup.depth`

```perl
#!/usr/bin/perl
my $line = 0;
my $sum = 0;
while(<>) {
	chomp;
	my ( $chr, $pos, $depth ) = split /\t/, $_;
	$line++;
	$sum += $depth;
}
print "bases: $line depth: $sum\n";
print "average: ", $sum/$line, "\n";
```

Running this results in:

    bases: 823134955 depth: 1876117779
    average: 2.27923473253544

I.e. low coverage: the average is 2.3, and only about 1% has coverage of over 10x

# SNP merging

## Make target list

Given run0220_paired_En-Tibi_S2_L003.fixmate.sorted.markdup.depth, creates a 2-column TSV (chromo,pos) with sites cover>=10,
i.e. mincover10.tsv, which is used by bcftools. 

```perl
while(<>) {
	chomp;
	@f = split /\t/, $_;
	last if $f[0] !~ /^\d+$/;
	if ( $f[2] >= 10 ) {		
		print sprintf('SL2.50ch%02d', $f[0]), "\t", $f[1], "\n";
	}
}
```

## Simplify the En Tibi snps:

    bcftools view --threads 3 -H -T mincover10_int_chromo.tsv run0220_paired_En-Tibi_S2_L003.fixmate.sorted.markdup.flt.vcf.gz \
        | grep -v LowQual \
        | egrep -v 'DP=\d;' \
        | grep -v INDEL > run0220_paired_En-Tibi_S2_L003.fixmate.sorted.markdup.flt.mincover10.vcf

An updated version of this step is parameterized slightly differently. Notice how previously the DP was treated as something to
filter with a grep (where any value of /^\d;$/ must implicitly be <10) where in the new version this filter is passed into
bcftools:

    bcftools view --threads 3 -H -e 'DP<10' -T output_Index_high_coverage_2.txt paired_En-Tibi.fixmate.sorted.markdup.flt.vcf \
        | grep -v LowQual \
        | grep -v INDEL \
	> paired_En-Tibi.fixmate.sorted.markdup.flt.mincover10.vcf

## Transform to CSV for [snps table](../script/schema.sql)

    perl ../360/accessions/gff2csv.pl run0220_paired_En-Tibi_S2_L003.fixmate.sorted.markdup.flt.mincover10.vcf \
        | sed -e 's/$/,En-Tibi/' > En-Tibi.csv

An updated version of this step produces output where the SNPs are not present/absent but have the raw ACGT values in it, i.e.:

    perl ../script/gff2csv_bases.pl paired_En-Tibi.fixmate.sorted.markdup.flt.mincover10.vcf \
        | sed -e 's/$/,En-Tibi/' > En-Tibi.csv

## Simplify and transform the 360 snps:

```bash
#!/bin/bash
accessions=$(ls *.vcf.gz | sed -e 's/.vcf.gz//')
for acc in $accessions; do
	bcftools view --threads 3 -H -T ../../bam/mincover10.tsv $acc.vcf.gz \
		| tee $acc.mincover10.vcf \
		| egrep -v 'DP=\d;' \
		| perl gff2csv.pl \
		| sed -e "s/$/,$acc/" > $acc.csv
done
```

### Statistical analysis

[t-SNE](https://rpubs.com/marwahsi/tnse)

```bash
FSDIR=/Users/rutger.vos/Documents/local-projects/fastStructure
Ks='2 3 4 5 6 7'
for K in $Ks; do
	python $FSDIR/structure.py -K $K \
		--input=structure.pruned \
		--format=str \
		--output=structure.pruned.out
done
python $FSDIR/chooseK.py --input=structure.pruned.out
```

Model complexity that maximizes marginal likelihood = 3
Model components used to explain structure in data = 4

```bash
DIR=/Users/rutger.vos/Documents/local-projects/tomatogenome-en-tibi/data/structure
pythonw distruct2.3.py \
    -K 3 \
    --input=$DIR/structure.pruned.out \
    --output=$DIR/structure.pruned.distruct23.pdf \
    --popfile=$DIR/labels.txt \
    --poporder=$DIR/poporder \
    --title="Structure analysis of S. pimpinellifolium, S. lycopersicum and S. l. var. cerasiforme"
```
