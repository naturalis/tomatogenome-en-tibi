#!/usr/bin/perl
use Data::Dumper;
my $individual=shift;
my $genotype=shift;
my $popu=shift;

$popu ||="ch";

open IN,$individual or die "$!";
my %id;
while(<IN>){
	chomp;
	my @f=split;
	$id{$f[0]}=1 if($f[2]=~/$popu/);
}
close IN;

open GENOTYPE,$genotype or die "$!";
while(<GENOTYPE>){
	chomp;
	my @inf=split(/\t/,$_);
	my @base=split(/\s+/,$inf[2]);
	my @aa;
	my %aa;
	for(my $i=0;$i<@base;$i++){
		my $index=$i+1;
		next unless ($id{$index});
		push @aa,$base[$i];		
	}
	print $inf[0],"\t",$inf[1],"\t",join (" ",@aa),"\n";
}
close GENOTYPE;
