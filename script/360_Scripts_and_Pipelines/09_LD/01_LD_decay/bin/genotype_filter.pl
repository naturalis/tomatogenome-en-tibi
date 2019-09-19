#!/usr/bin/perl -w
use strict;
use File::Basename;
#explanation:this program is edited to 
#edit by zengpeng;   Fri Apr 19 13:22:17 CST 2013
#Version 1.0    zengpeng@genomics.org.cn 

die  "Version 1.0\t2013-04-19;\nUsage: $0 <Genotype><Dis>\n" if(@ARGV < 1);

#############Befor  Start  , open the files ####################

my $genotype=shift;
my $dis=shift;

my $out_name=basename $genotype;


open (IA,"$genotype") || die "input file can't open $!";

#open (OA,">$ARGV[1]") || die "output file can't open $!" ;

################ Do what you want to do #######################
my %hash;
while(<IA>) { 
		chomp ; 
		my @inf=split ;
		my $st=$inf[1] - $dis;
		my $en=$inf[1] + $dis;
		for my $i($st..$en){
			next if($i ==$inf[1]);
			$hash{$i}++;
		}
	}

close IA;
#close OA ;

open OUT,">$out_name" or die  "$!";
open (IA,"$genotype") || die "input file can't open $!";
while(<IA>) {
                chomp ;
                my @inf=split ;
		next if($hash{$inf[1]});
		print OUT "$_\n";
}
close IA;
close OUT;


######################swimming in the sky and flying in the sea ###########################
