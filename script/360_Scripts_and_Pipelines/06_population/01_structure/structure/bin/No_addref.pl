#!/usr/bin/perl-w
use strict;
#explanation:this program is edited to 
#edit by HeWeiMing;   Mon Sep 13 11:41:23 CST 2010
#Version 1.0    hewm@genomics.org.cn 

die  "Version 1.0\t2010-09-13;\nUsage: $0 <add_ref>\n" unless (@ARGV ==1);

#############Befor  Start  , open the files ####################

open IA,"$ARGV[0]"  || die "input file can't open $!" ;

#open OA,">$ARGV[2]" || die "output file can't open $!" ;

################ Do what you want to do #######################

	while(<IA>) 
	{ 
		chomp ; 
		my @inf=split ;
        my $line=join(" ",@inf[3..$#inf]);
        print $inf[0],"\t$inf[1]\t$line\n";
	}

close IA;
#close OA ;

######################swimming in the sky and flying in the sea ###########################
