#!/usr/bin/perl-w
use strict;
#explanation:this program is edited to 
#edit by HeWeiMing;   Sun Oct 31 22:03:05 CST 2010
#Version 1.0    hewm@genomics.org.cn 
die  "Version 1.0\t2010-10-31;\nUsage: $0 <Info.out><land_id><out>\n" unless (@ARGV ==3);
#############Befor  Start  , open the files ####################
open (IA,"<$ARGV[0]") || die "input file can't open $!";
open (OA,">$ARGV[2]") || die "output file can't open $!" ;
################ Do what you want to do #######################
        $_=<IA> ;
		chomp ; 
		my @inf=split ;
		print OA  "$ARGV[1]\t$inf[-5]\t$inf[-2]\t$inf[-1]\n";
close IA;
close OA ;
######################swimming in the sky and flying in the sea ###########################
