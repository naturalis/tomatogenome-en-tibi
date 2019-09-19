#!/usr/bin/perl
my $loci=shift;
my $raw=shift;
my $chr=shift;
open IN,$loci;
my %loci;
while(<IN>){
	chomp;
	my @inf=split;
	if($inf[0] eq $chr){
		$loci{$inf[1]}=1;
	}
}
close IN;

open RAW,$raw or die  "$!";
while(<RAW>){
	chomp;
	my @inf=split;
	if($loci{$inf[1]}){
		print "$inf[0]\t$inf[1]\t$inf[7]\n" if($inf[2] eq $inf[6]);
		print "$inf[0]\t$inf[1]\t$inf[8]\n" if($inf[2] eq $inf[5]);
		if($inf[2] ne $inf[5] and $inf[2] ne $inf[6]){
			my $count=$inf[7]+$inf[8];
			print "$inf[0]\t$inf[1]\t$count\n";
		}
	}
}
close RAW;

