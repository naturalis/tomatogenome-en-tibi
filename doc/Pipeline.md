# Pre-processing

## Quality assessment and trimming

	fastp \
		-i run0220_En-Tibi_S2_L003_R1_001.nophix.fastq.gz \
		-I run0220_En-Tibi_S2_L003_R2_001.nophix.fastq.gz \
		-o R1_fastp.fastq.gz \
		-O R2_fastp.fastq.gz \
		-j fastp.json -h fastp.html --verbose

# Assembly

## Indexing the reference

	minimap2 \
		-d Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz.mmi \
		-t 4 \
		Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz

## Mapping

	minimap2 \
		-ax sr \
		-a \
		-t 4 \
		Solanum_lycopersicum.SL2.50.dna.toplevel.fa.gz \
		R1_fastp.fastq.gz R2_fastp.fastq.gz | samtools view \
		-b -u -F 0x04 --threads 4 -o run0220_En-Tibi_S2_L003.bam -

## Correct mate pairs

	samtools \
		fixmate -r -m  \
		--threads 4 \
		run0220_En-Tibi_S2_L003.bam \
		run0220_En-Tibi_S2_L003.fixmate.bam

## Sort the reads

	samtools \
		sort -l 0 \
		-m 3G \
		--threads 4 \
		-o run0220_En-Tibi_S2_L003.fixmate.sorted.bam run0220_En-Tibi_S2_L003.fixmate.bam

## Mark duplicates

	samtools \
		markdup -r \
		--threads 4 \
		run0220_En-Tibi_S2_L003.fixmate.sorted.bam \
		run0220_En-Tibi_S2_L003.fixmate.sorted.markdup.bam

# SNP calling

## Basic stats

Number of bases with at least 10x coverage:

	export MIN_COVERAGE_DEPTH=10	
	samtools mpileup run0220_En-Tibi_S2_L003.fixmate.sorted.markdup.bam | awk -v X="${MIN_COVERAGE_DEPTH}" '$4>=X' | wc -l

    #     Answer:   9,894,824
    # Ref length: 823,134,955
    # i.e., about 1% has a coverage of >=10x

Get all the depths (useful for plotting histograms):

	samtools depth -a run0220_En-Tibi_S2_L003.fixmate.sorted.markdup.bam > run0220_En-Tibi_S2_L003.fixmate.sorted.markdup.depth

Compute the averages:

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

	MacBook-Pro-Rutger-Vos:bam rutger.vos$ perl avgdepth.pl run0220_En-Tibi_S2_L003.fixmate.sorted.markdup.depth 
	bases: 823134955 depth: 1878040045
	average: 2.28157003124718

I.e. low coverage: the average is 2.2, and only about 1% has coverage of over 10x

## Index the reference

	samtools faidx Solanum_lycopersicum.SL2.50.dna.toplevel.fa

## Do the thing

	bcftools mpileup \
		-Ou \
		-f ../reference/Solanum_lycopersicum.SL2.50.dna.toplevel.fa \
		run0220_En-Tibi_S2_L003.fixmate.sorted.markdup.bam \
		| bcftools call -Ou -mv \
		| bcftools filter -s LowQual -e '%QUAL<20 || DP>20' \
		> run0220_En-Tibi_S2_L003.fixmate.sorted.markdup.flt.vcf

# SNP merging

## Simplify the En Tibi snps:

	grep -v '#' run0220_En-Tibi_S2_L003.fixmate.sorted.markdup.flt.vcf \
		| grep -v LowQual \
		| grep -v INDEL \
		| cut -f1,2,4,5 \
		| grep -v SL2.40sc \
		> snps.tsv

## Simplify the 360 snps:

```bash
vcfs=`ls *.vcf`
for vcf in $vcfs; do
	cut -f1,2,4,5 $vcf \
		| sed -e 's/SL2.50ch//' \
		| grep -v '#' \
		| grep -v '^00' \
		| sed -e 's/^0//' \
		> $vcf.tsv
done
```
