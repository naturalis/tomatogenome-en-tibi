#!/usr/bin/perl-w
use strict;
#explanation:this program is edited to 
#Version 1.0    liuxin@genomics.org.cn 

die  "Version 1.0\t2011-04-8;\nUsage: $0 <InPut>\n" unless (@ARGV == 3);

open GF,"$ARGV[0]"  || die "Gff file can't open $!";
open SN,"$ARGV[1]" || die "SNP file can't open $!";

my $chr=$ARGV[2];

my %pos_plus;
my %pos_minus;


my %priority=(
	'Exon'=>'4',
	'5_UTR'=>'3',
	'3_UTR'=>'2',
	'Intron'=>'1',
);

while(<GF>) 
{ 
	chomp; 
	my @line=split(/\t/,);
	next unless $line[0] eq $chr;
	/ID=(\S+);/;
	if($line[2] eq "mRNA")
	{
		for(my $i=$line[3];$i<=$line[4];$i++)
		{
			$pos_plus{$i}="Intron\t$1" if($line[6] eq '+');
			$pos_minus{$i}="Intron\t$1" if($line[6] eq '-');
		}
	}
	if($line[2] eq "five_prime_utr")
	{
		for(my $i=$line[3];$i<=$line[4];$i++)
		{
			$pos_plus{$i}="5_UTR\t$1" if($line[6] eq '+');
			$pos_minus{$i}="5_UTR\t$1" if($line[6] eq '-');
		}
	}
	if($line[2] eq "CDS")
	{
		for(my $i=$line[3];$i<=$line[4];$i++)
		{
			$pos_plus{$i}="Exon\t$1" if($line[6] eq '+');
			$pos_minus{$i}="Exon\t$1" if($line[6] eq '-');
		}
	}
	if($line[2] eq "three_prime_utr")
	{
		for(my $i=$line[3];$i<=$line[4];$i++)
		{
			$pos_plus{$i}="3_UTR\t$1" if($line[6] eq '+');
			$pos_minus{$i}="3_UTR\t$1" if($line[6] eq '-');
		}
	}
}

while(<SN>)
{
	chomp;
	my @line=split;
	if(exists($pos_plus{$line[1]}) && exists($pos_minus{$line[1]})){
		my $aa=&priority($pos_plus{$line[1]},$pos_minus{$line[1]});
		print "$line[0]\t$line[1]\t$aa\n";	
	}elsif(exists($pos_plus{$line[1]}) && !exists($pos_minus{$line[1]})){
		print "$line[0]\t$line[1]\t$pos_plus{$line[1]}\n";
	}elsif(exists($pos_minus{$line[1]}) && !exists($pos_plus{$line[1]})){
		print "$line[0]\t$line[1]\t$pos_minus{$line[1]}\n";
	}else{
		print "$line[0]\t$line[1]\tIntergenic\n";
	}
}

close GF;
close SN;


sub priority{
	my $plus=shift;
	my $minus=shift;
	my$plus_type=(split(/\t/,$plus))[0];
	my$minus_type=(split(/\t/,$minus))[0];
	$plus_type=$priority{$plus_type};
	$minus_type=$priority{$minus_type};
	if($plus_type<$minus_type){
		return $minus;
	}else{
		return $plus;
	}
}


