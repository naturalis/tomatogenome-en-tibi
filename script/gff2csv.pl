use strict;
use warnings;

# transforms GFF columns into CSV for the SNP table in the database
while(<>) {
	chomp;
	s/SL2\.50ch0*//;
	my ( $chromo, $pos, $id, $ref, $alt ) = split /\t/, $_;
	#  values of 0, 1, or 2 for homozygous ref, het, homoz alt.
	my $state = $alt =~ /,/ ? 2 : 1;
	print join(',', $chromo, $pos, $state), "\n";
}
