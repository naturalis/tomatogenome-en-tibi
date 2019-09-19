#!/usr/bin/perl -w
use strict;
#explanation:this program is edited to 
#edit by liuxin;   Thu Apr 28 13:47:53 CST 2011
#Version 1.0    liuxin@genomics.org.cn 

die  "Version 1.0\t2011-04-28;\nUsage: $0 <InPut><Out>\n" unless (@ARGV ==2);

#############Befor  Start  , open the files ####################

open (IA,"$ARGV[0]") || die "input file can't open $!";

my @c=(11,35,37,39,161);
my @w=(57,58,59,60,61);
open OA,">c.csv" or die "$!";
open OB,">w.csv" or die "$!";
open OI,">info.txt" or die "$!";

#open (OA,">$ARGV[1]") || die "output file can't open $!" ;

################ Do what you want to do #######################

my %iupac=(
    "A"=>"A A",
    "C"=>"C C",
    "G"=>"G G",
    "T"=>"T T",
    "M"=>"A C",
    "K"=>"G T",
    "Y"=>"C T",
    "R"=>"A G",
    "W"=>"A T",
    "S"=>"C G",
    "-"=>"- -",
    "N"=>"- -",
);

my (@csv1,@csv2,$chr);
$csv1[0]=$csv2[0]="SAMPLE,";
	while(<IA>) 
	{ 
		chomp ; 
		my @inf=split;
        $chr=$inf[0];
        $csv1[0].="$inf[1],";
        $csv2[0].="$inf[1],";
        my $i=1;
        
        foreach my $cu (sort {$a<=>$b} @c)
        {
            my $index=$cu+1;
            $csv1[$i].="$iupac{$inf[$index]},";
            $i++;
        }
        $i=1;
        foreach my $wi (sort {$a<=>$b} @w)
        {
            my $index=$wi+1;
            $csv2[$i].="$iupac{$inf[$index]},";
            $i++;
        }
	}
    chop($csv1[0]);
    print OA "$csv1[0]\n";
    for(my $i=1;$i<@csv1;$i++)
    {
        chop($csv1[$i]);
        print OA "C$i,$csv1[$i]\n";
    }
    chop($csv2[0]);
    print OB "$csv2[0]\n";
    for(my $i=1;$i<@csv2;$i++)
    {
        chop($csv2[$i]);
        print OB "W$i,$csv2[$i]\n";
    }
    
    my $info=$csv1[0];
    $info=~s/SAMPLE//;
    $info=~s/,/\t/g;
    print OI "$chr\t$ARGV[1]$info\n";


close IA;
close OA;
close OB;
close OI;
######################swimming in the sky and flying in the sea ###########################
