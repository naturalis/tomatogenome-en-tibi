#!/usr/bin/perl 
use strict;
use File::Basename;
#explanation:this program is edited to change genotype form to run EIG of PCA; 
#edit by zengpeng;   Thu Mar 15 17:31:42 CST 2012
#Version 1.0    zengpeng@genomics.org.cn 

die  "Version 1.0\t2012-03-15;\nUsage: $0 <InPut><Out>\n" unless (@ARGV ==1);

#############Befor  Start  , open the files ####################


#(AC)   M
#(AG)   R
#(AT)   W
#(CG)   S
#(CT)   Y
#(GT)   K

my %het=(
	'M'=>'AC',
	'R'=>'AG',
	'W'=>'AT',
	'S'=>'CG',
	'Y'=>'CT',
	'K'=>'GT',
	'V'=>'ACG',
	'D'=>'ATG',
	'B'=>'CTG',
	'H'=>'ATC',
	'N'=>'ATCG'	
);

open (IA,"$ARGV[0]") || die "input file can't open $!";
my $filename= basename $ARGV[0];
my $chr=(split(/\./,$filename))[0];
open GE,">$chr.geno" or die "$!";
open SNP,">$chr.snp" or die "$!";
my $chr_num=$chr;
###	Changed by lintao	###
#$chr_num=~s/\D+//g;
$chr_num=~s/\D+0//g;
$chr_num=~s/\D+//g;
###	Changed by lintao	###
$chr_num=8 unless ($chr_num);
#open (OA,">$ARGV[1]") || die "output file can't open $!" ;

################ Do what you want to do #######################

#  0 means zero copies of reference allele.
#  1 means one copy of reference allele.
#  2 means two copies of reference allele.
#  9 means missing data.
#rs4444  11        0.004000          400000 G A

my $ref_base;
my $variant;
while(<IA>){ 
	chomp ; 
	my @inf=split(/\t/,$_);
###	Changed by lintao	###
#	my @base=split(/\s+/,$inf[2]);
#	$ref_base=shift @base;
	my @base=split(/\s+/,$inf[3]);
	$ref_base=$inf[2];
###	Changed by lintao	###
	for(my $i=0;$i<@base;$i++){
		print GE change($base[$i]);	
		#last if(!$variant && $variant ne $ref_base);
	}
	print GE "\n";
	print SNP "$inf[0]snp$inf[1]\t$chr_num\t0.0\t$inf[1]\t$ref_base\t$variant\n";
}

close GE;
close SNP;
close IA;
#close OA ;

sub change{
	my $base_sub=shift;
	if($base_sub eq $ref_base){
		return 2;
	}elsif($base_sub eq '-'){
		return 9;
	}elsif($het{$base_sub}=~/$ref_base/){
		$variant=$het{$base_sub};	
		$variant=~s/$ref_base//g;		
		return 1;
	}else{
		return 0;
	}
}



######################swimming in the sky and flying in the sea ###########################
