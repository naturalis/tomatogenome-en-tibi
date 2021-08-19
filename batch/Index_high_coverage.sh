#!/usr/bin/perl
#Given paired_En-Tibi.fixmate.sorted.markdup.depth, creates a 2-column TSV (chromo,pos) with sites cover>=10,
#i.e. mincover10.tsv, which is used by bcftools.
#SBATCH --job-name=index_coverage
#SBATCH --output=output_Index_high_coverage.txt

while(<>) {
	chomp;
	@f = split /\t/, $_;
	last if $f[0] !~ /^\d+$/;
	if ( $f[2] >= 10 ) {
#		print sprintf('SL2.50ch%02d', $f[0]), "\t", $f[1], "\n";
                printf("%d\t%d\n", $f[0], $f[1]);
	}
}
