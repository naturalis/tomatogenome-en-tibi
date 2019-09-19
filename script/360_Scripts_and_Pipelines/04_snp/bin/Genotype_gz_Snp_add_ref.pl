#!/usr/bin/perl-w
use strict;
use Data::Dumper;
use Getopt::Long;
use lib "/nas/RD_09C/resequencing/soft/lib/perl5/site_perl/5.8.5" ;
use Compress::Zlib ;

#explanation:this program is edited to 
#edit by HeWeiMing;   Wed Oct 14 15:16:22 CST 2009
#Version 1.0    hewm@genomics.org.cn 

die"Version 1.0\t2009-10-14;\nUsage: $0 <GenotyepSnp.gz><Ref_chr.fa><Out>\n" unless (@ARGV ==3);

#############Befor  Start  , open the files ####################

my %jianbin=(
	'V'	=>	'A+C+G',
	'D'	=>	'A+T+G',
	'B'	=>	'T+C+G',
	'H'	=>	'A+T+C',
	'W'	=>	'A+T',
	'S'	=>	'C+G',
	'K'	=>	'T+G',
	'M'	=>	'A+C',
	'Y'	=>	'C+T',
	'R'	=>	'A+G',
	'N'	=>	'A+G+C+T',
);



#open (IA,"<$ARGV[0]")  || die "input file can't open $!" ;
my $gz=gzopen($ARGV[0],"rb") || die $!;
open (IB,"<$ARGV[1]")  || die "input file can't open $!" ;
my $out_Genotyep="$ARGV[2].new.genotype";
my $out_Genotyep_st="$ARGV[2].new.genotype.st";



open (OA,">$out_Genotyep") || die "output file can't open $!" ;
open (OB,">$out_Genotyep_st") || die "output file can't open $!" ;




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
#    while(<IA>)
while($gz->gzreadline($_) > 0){
	chomp ;
	my @inf=split /\s+/;
	my $base=join(" ",@inf[2..$#inf]);
	my $lie=substr($ref,$inf[1]-1,1);
#	print OA $inf[0],"\t",$inf[1],"\t",$lie,"\t",$base,"\n";
	print OB $inf[0],"\t",$inf[1],"\t",$lie;
	
	my $chr=shift @inf;
	my $loci=shift @inf;
	my %hash;
	for my $base(@inf){
		$hash{$base}++;
	}
	my @base;
	foreach my $base(keys %hash){
		push @base,[$base,$hash{$base}];
	}
	@base=sort {$b->[1]<=>$a->[1]}@base;
	for (my $i=0;$i<@base;$i++){
		print OB "\t$base[$i][0]\t$base[$i][1]";
	}
	print OB "\n";
	my %aa;
	for my $ba(@base){
		next if($ba eq '-');
		if($jianbin{$ba}){
			my @bb=split(/\+/,$jianbin{$ba});
			for my $bb(@bb){
				$aa{$bb}+=$hash{$ba};
			}
		}else{
			$aa{$ba}+=(2*$hash{$ba});
		}
	}
	my @aa=keys %aa;
	next unless (@aa==2);
	print OA $chr,"\t",$loci,"\t",$lie," ",$base,"\n";
}
close OA ;
close OB ;
close IB;
$gz->gzclose();
#close IA;
##############swiming in the sky and flying in the sea #######################
