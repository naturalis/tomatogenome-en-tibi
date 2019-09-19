#!/usr/bin/perl -w
use strict;
#explanation:this program is edited to 
#edit by liuxin;   Wed Apr 20 15:33:09 CST 2011
#Version 1.0    liuxin@genomics.org.cn 

die  "Version 1.0\t2011-04-20;\nUsage: $0 <InPut><Out>\n" unless (@ARGV ==3);

#############Befor  Start  , open the files ####################

open (IA,"$ARGV[0]") || die "input file can't open $!";

my $soap_dir=$ARGV[1];
my $out_dir=$ARGV[2];

mkdir $out_dir unless (-d $out_dir );

#open (OA,">$ARGV[1]") || die "output file can't open $!" ;

################ Do what you want to do #######################

	while(<IA>) 
	{ 
		chomp ; 
		my @inf=split;
        `cat    $soap_dir/$inf[1]/indel-result.list >> $out_dir/Indel_$inf[0].list`;
		
	}


close IA;
#close OA ;

######################swimming in the sky and flying in the sea ###########################
