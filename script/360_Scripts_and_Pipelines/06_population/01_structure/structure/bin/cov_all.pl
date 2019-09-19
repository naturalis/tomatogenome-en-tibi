#!/usr/bin/perl-w
use strict;
#explanation:this program is edited to 
#edit by HeWeiMing;   Tue Oct 13 16:28:40 CST 2009
#Version 1.0    hewm@genomics.org.cn 

die  "Version 1.0\t2009-10-13;\nUsage: $0 <genotype_SNP>\n" unless (@ARGV ==1);

#############Befor  Start  , open the files ####################

open IA,"$ARGV[0]"  || die "input file can't open $!" ;

#open OA,">$ARGV[2]" || die "output file can't open $!" ;
################ Do what you want to do #######################

	while(<IA>) 
	{ 
        my @inf=split /\t/ ,$_ ;
        my $s=$inf[2] ;
        next if ($s =~ /-/);
=aa
     next if ($s =~ /M/); 
     next if ($s =~ /K/);
     next if ($s =~ /Y/);
     next if ($s =~ /R/);
     next if ($s =~ /W/);
     next if ($s =~ /S/);i
=cut
        print $inf[0],"\t$inf[1]\t$inf[2]";
	}
close IA;
#close OA ;

############swimming in the sky and flying in the sea ###############
