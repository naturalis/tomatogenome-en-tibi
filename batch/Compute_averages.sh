#!/usr/bin/perl
#SBATCH --job-name=Compute_averages
#SBATCH --output=output_Compute_averages.txt

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