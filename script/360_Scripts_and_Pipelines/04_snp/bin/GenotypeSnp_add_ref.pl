#!/usr/bin/perl-w
use strict;
#explanation:this program is edited to 
#edit by HeWeiMing;   Wed Oct 14 15:16:22 CST 2009
#Version 1.0    hewm@genomics.org.cn 

die"Version 1.0\t2009-10-14;\nUsage: $0 <GenotyepSnp><Ref_chr.fa><OutDir>\n" unless (@ARGV ==3);

#############Befor  Start  , open the files ####################

open (IA,"<$ARGV[0]")  || die "input file can't open $!" ;
open (IB,"<$ARGV[1]")  || die "input file can't open $!" ;
open (OA,">$ARGV[2]") || die "output file can't open $!" ;

################ Do what you want to do #######################
$/=">"; 
<IB> ;
my  $ref=();
while(<IB>){ 
	chomp ; 
	my @inf=split /\n/;
	$ref=join("",@inf[1..$#inf]) ;   
}
$ref=uc($ref);
$/="\n";

while(<IA>){
	chomp ;
	my @inf=split /\s+/;
	my $base=join(" ",@inf[2..$#inf]);
	my $lie=substr($ref,$inf[1]-1,1);
	print OA $inf[0],"\t",$inf[1],"\t",$lie,"\t",$base,"\n";
}
close OA ;
close IB;
close IA;
##############swiming in the sky and flying in the sea #######################
