#!/usr/bin/perl -w
use strict;
#explanation:this program is edited to 
#edit by liuxin;   Thu May 12 15:01:59 CST 2011
#Version 1.0    liuxin@genomics.org.cn 

die  "Version 1.0\t2011-05-12;\nUsage: $0 <chr fa><total snp file (pos)><group 1 raw><group 2 raw><group 3 raw>\n" unless (@ARGV ==5);

#############Befor  Start  , open the files ####################
##This data is population SNPs info for 2 soybean population
#Ref     Outgroup        Allele1 wild    cultivated      Allele2 wild    cultivated      Chr     Pos
#TAT     TAT     A       15      18      C       15      10      Gm01    394
#
open (FA,"$ARGV[0]") || die "input file can't open $!";
open SN,"$ARGV[1]" or die "$!";
open G1,"$ARGV[2]" or die "$!";
open G2,"$ARGV[3]" or die "$!";
open G3,"$ARGV[4]" or die "$!";
#open G4,"$ARGV[5]" or die "$!";

#open (OA,">$ARGV[1]") || die "output file can't open $!" ;

################ Do what you want to do #######################

print "#This data is genome-wide snp info for 3 tomato population\n"; 	#lintao
print "Ref\tOutgroup\tAllele1\tbig\tcerasi\tpimp\tAllele2\tbig\tcerasi\tpimp\tChr\tPos\n";

my ($seq,%dadi);

$/=">";
<FA>;
	while(<FA>)
	{
		chomp ; 
		my @inf=split(/\n/,);
        shift(@inf);
        $seq=join("",@inf);
	}

    $/="\n";

    while(<SN>)
    {
        chomp;
        my @inf=split;
        
        my $ref=substr($seq,$inf[1]-1,1);
        my $ref_seq=substr($seq,$inf[1]-2,3);
        my ($ref_fre,$other,$other_fre);
        $other=$inf[2] eq $inf[5]?$inf[6]:$inf[5];

        $dadi{$inf[1]}="$ref_seq\t$ref_seq\t$ref\t$other\t$inf[0]\t$inf[1]";
    }

    while(<G1>)
    {
        chomp;
        my @inf=split;
        if(exists($dadi{$inf[1]}))
        {
            my @tmp=split(/\t/,$dadi{$inf[1]});
            if($inf[5] eq $tmp[2])
            {
                $dadi{$inf[1]}="$tmp[0]\t$tmp[1]\t$tmp[2]\t$inf[7]\t$tmp[3]\t$inf[8]\t$tmp[4]\t$tmp[5]";
            }
            else
            {
                $dadi{$inf[1]}="$tmp[0]\t$tmp[1]\t$tmp[2]\t$inf[8]\t$tmp[3]\t$inf[7]\t$tmp[4]\t$tmp[5]";
            }
        }
    }
    while(<G2>)
    {
        chomp;
        my @inf=split;
        if(exists($dadi{$inf[1]}))
        {
            my @tmp=split(/\t/,$dadi{$inf[1]});
            if($inf[5] eq $tmp[2])
            {
                $dadi{$inf[1]}="$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$inf[7]\t$tmp[4]\t$tmp[5]\t$inf[8]\t$tmp[6]\t$tmp[7]";
            }
            else
            {
                $dadi{$inf[1]}="$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$inf[8]\t$tmp[4]\t$tmp[5]\t$inf[7]\t$tmp[6]\t$tmp[7]";
            }
        }
    }
#    while(<G3>)
#    {
#        chomp;
#        my @inf=split;
#        if(exists($dadi{$inf[1]}))
#        {
#            my @tmp=split(/\t/,$dadi{$inf[1]});
#            if($inf[5] eq $tmp[2])
#            {
#                $dadi{$inf[1]}="$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$tmp[4]\t$inf[7]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t$inf[8]\t$tmp[8]\t$tmp[9]";
#            }
#            else
#            {
#                $dadi{$inf[1]}="$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$tmp[4]\t$inf[8]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t$inf[7]\t$tmp[8]\t$tmp[9]";
#            }
#        }
#    }
#    print "#This data is genome-wide snp info for 4 cucumber population\n";
#    print "Ref\tOutgroup\tAllele1\tEastAsian\tEurasian\tIndian\tXishuangbanna\tAllele2\tEastAsian\tEurasian\tIndian\tXishuangbanna\tChr\tPos\n";
    while(<G3>)
    {
        chomp;
        my @inf=split;
        if(exists($dadi{$inf[1]}))
        {
            my @tmp=split(/\t/,$dadi{$inf[1]});
            if($inf[5] eq $tmp[2])
            {
                print "$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$tmp[4]\t$inf[7]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t$inf[8]\t$tmp[8]\t$tmp[9]\n";
#                print "$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$inf[7]\t$tmp[6]\t$tmp[7]\t$tmp[8]\t$tmp[9]\t$inf[8]\t$tmp[10]\t$tmp[11]\n";
            }
            else
            {
                print "$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$tmp[4]\t$inf[8]\t$tmp[5]\t$tmp[6]\t$tmp[7]\t$inf[7]\t$tmp[8]\t$tmp[9]\n";
#                print "$tmp[0]\t$tmp[1]\t$tmp[2]\t$tmp[3]\t$tmp[4]\t$tmp[5]\t$inf[8]\t$tmp[6]\t$tmp[7]\t$tmp[8]\t$tmp[9]\t$inf[7]\t$tmp[10]\t$tmp[11]\n";
            }
        }
    }
#    print "#This data is genome-wide snp info for 4 cucumber population\n";
#    print "#This data is genome-wide snp info for 3 tomato population\n"; lintao
#    print "Ref\tOutgroup\tAllele1\tEastAsian\tEurasian\tIndian\tXishuangbanna\tAllele2\tEastAsian\tEurasian\tIndian\tXishuangbanna\tChr\tPos\n";

#close OA ;

######################swimming in the sky and flying in the sea ###########################
