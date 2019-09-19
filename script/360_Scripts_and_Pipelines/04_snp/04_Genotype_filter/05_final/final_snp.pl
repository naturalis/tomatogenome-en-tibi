#!/usr/bin/perl
my ($chisq,$fish,$genotype)=@ARGV;

my %hash;
open IN,$chisq or die  "$!";
while(<IN>){
	chomp;
	my @f=split;
	$hash{$f[1]}=1;
}
close IN;

my %hash_2;
open IN,$fish or die  "$!";
while(<IN>){
        chomp;
        my @f=split;
	$hash_2{$f[1]}=1 if( $hash{$f[1]} );
}
close IN;

open GE,$genotype or die "$!";
while(<GE>){
	chomp;
	my @f=split;
	print $_,"\n" if($hash_2{$f[1]});
}
close GE;


