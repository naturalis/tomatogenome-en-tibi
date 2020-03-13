# Pre-processing

## Quality assessment and trimming

    fastp \
            -i "/home/rutger.vos/fileserver/projects/B19015-525/updated/run0220_En-Tibi_S2_L003_R1_001.nophix.fastq.gz" \
            -I "/home/rutger.vos/fileserver/projects/B19015-525/updated/run0220_En-Tibi_S2_L003_R2_001.nophix.fastq.gz" \
            -o "paired_R1_fastp.fastq.gz" \
            -O "paired_R2_fastp.fastq.gz" \
            -j fastp.json -h fastp.html --verbose

# Assembly

## Indexing the reference

    minimap2 \
        -d "../reference/Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz.mmi" \
        -t 4 \
        "../reference/Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz"

## Mapping

    minimap2 \
        -ax sr \
        -a \
        -t 4 \
        "../reference/Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz.mmi" \
        "paired_R1_fastp.fastq.gz" "paired_R2_fastp.fastq.gz" | samtools view \
        -b -u -F 0x04 --threads 4 -o "paired_En-Tibi.bam" -

## Correct mate pairs

	samtools \
        fixmate -r -m  \
        --threads 4 \
        "paired_En-Tibi.bam" \
        "paired_En-Tibi.fixmate.bam"

## Sort the reads

    samtools \
      sort -l 0 \
      -m 3G \
      --threads 4 \
      -o "paired_En-Tibi.fixmate.sorted.bam" "paired_En-Tibi.fixmate.bam"

## Mark duplicates

    samtools \
      markdup -r \
      --threads 4 \
      "paired_En-Tibi.fixmate.sorted.bam" \
      "paired_En-Tibi.fixmate.sorted.markdup.bam"

# SNP calling

## Basic stats

Number of bases with at least 10x coverage:

    export MIN_COVERAGE_DEPTH=10
    samtools mpileup "paired_En-Tibi.fixmate.sorted.markdup.bam" | awk -v X="${MIN_COVERAGE_DEPTH}" '$4>=X' | wc -l

    #     Answer:   6072146
    # Ref length: 823,134,955
    # i.e., about 0.75% has a coverage of >=10x

Get all the depths (useful for plotting histograms):

    samtools depth -a "paired_En-Tibi.fixmate.sorted.markdup.bam" > "paired_En-Tibi.fixmate.sorted.markdup.depth"


I.e. low coverage: the average is 2.2, and only about 1% has coverage of over 10x

## Index the reference

    samtools faidx ../reference/Solanum_lycopersicum.SL2.50.dna.toplevel.fa \
      -o ../reference/Solanum_lycopersicum.SL.2.50.dna.toplevel.fa.fai

## Do the SNP calling

    bcftools mpileup \
      -Ou \
      -f ../reference/Solanum_lycopersicum.SL2.50.dna.toplevel.fa \
      paired_En-Tibi.fixmate.sorted.markdup.bam \
      | bcftools call -Ou -mv \
      | bcftools filter -s LowQual -e '%QUAL<20 || DP>20' \
      > paired_En-Tibi.fixmate.sorted.markdup.flt.vcf

## Compute the averages:

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

Running this results in:
 
    bases: 823154808 depth: 1226874728
    average: 1.49045442737668

# SNP merging

## Make target list

Given paired_En-Tibi.fixmate.sorted.markdup.depth, creates a 2-column TSV (chromo,pos) with sites cover>=10,
i.e. mincover10.tsv, which is used by bcftools. 

```perl
while(<>) {
	chomp;
	@f = split /\t/, $_;
	last if $f[0] !~ /^\d+$/;
	if ( $f[2] >= 10 ) {
#		print sprintf('SL2.50ch%02d', $f[0]), "\t", $f[1], "\n";
                printf("%d\t%d\n", $f[0], $f[1]);
	}
}
```

## Simplify the En Tibi snps:

    bcftools view --threads 3 -H -e 'DP<10' -T output_Index_high_coverage.txt \
	paired_En-Tibi.fixmate.sorted.markdup.flt.vcf \
        | grep -v LowQual \
        | grep -v INDEL \
	> paired_En-Tibi.fixmate.sorted.markdup.flt.mincover10.vcf

## Transform to CSV for [snps table](../script/schema.sql)

    perl ../script/gff2csv.pl paired_En-Tibi.fixmate.sorted.markdup.flt.mincover10.vcf \
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