#!/usr/bin/perl-w
use strict;
#explanation:this program is edited to 
#edit by heweiming;    2009-7-8

die"Usage: $0 <InPut_indivi_snp><out_genotype>\n" unless (@ARGV == 2);

open SNP,$ARGV[0] or die "A$!\n";
open OUT,">$ARGV[1]" or die "$!\n";

while(<SNP>)
{
	chomp;
	my @snp=split;
	my $seq=();
	for(my $i=3;$i<=$#snp-3;$i+=3)
	{
		if($snp[$i+2]==0){$snp[$i]="-";}

		if($i==3)
		{
			$seq=$seq.$snp[$i]; 
		}
		else
		{
			$seq=$seq." ".$snp[$i];
		}
	}
	my $A=($seq=~s/A/A/g)+0;
	my $T=($seq=~s/T/T/g)+0;
	my $C=($seq=~s/C/C/g)+0;
	my $G=($seq=~s/G/G/g)+0;
	my $N=($seq=~s/-/-/g)+0;
	my @Arr=split(/\s+/,$seq );
	my $sample=$#Arr+1;
	my $genotype=join(" ",@Arr);
	next if ($A+$N==$sample || $G+$N==$sample ||$C+$N==$sample ||$T+$N==$sample );
	print OUT "$snp[0]\t$snp[1]\t$genotype\n"; 
}
close SNP ; 
close OUT;
