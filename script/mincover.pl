#!/usr/bin/perl
use strict;
use warnings;

# given run0220_En-Tibi_S2_L003.fixmate.sorted.markdup.depth, creates a 2-column TSV (chromo,pos) with sites cover>=10
# NOTE:
# - when rerunning this, Ewout used paired_En-Tibi.fixmate.sorted.markdup.depth
# - in that reimplementation, the release prefix 'SL2.50ch' was no longer needed

while(<>) {
	chomp;
	@f = split /\t/, $_;
	last if $f[0] !~ /^\d+$/;
	if ( $f[2] >= 10 ) {		
		print sprintf('SL2.50ch%02d', $f[0]), "\t", $f[1], "\n";
	}
}
