#!/usr/bin/perl-w
use strict;
#explanation:this program is edited to 
#edit by HeWeiMing;   Thu Jan 27 18:00:43 CST 2011
#Version 1.0    hewm@genomics.org.cn 
die  "Version 1.0\tt2011-01-27;\nUsage: $0 <InPut><OUT>\n" unless (@ARGV ==1);
#############Befor  Start  , open the files ####################
open (IA,"$ARGV[0]") || die "output file can't open $!" ;

################ Do what you want to do #######################

my (%list,%RR,%Dp,%count);

	while($_=<IA>) 
	{ 
		chomp ; 
		my @inf=split;
    #    if($inf[4]>0.8)# && $inf[7]>150000)
   #     {
  #         next;
 #       }
        if($inf[4]>0.9)	# && $inf[7]<50000)	#lintao change
        #if($inf[4]>0.2 && $inf[7]<50000)
        {
           $list{$inf[1]}=1;
        }
        if(!exists($list{$inf[0]}))
        {
            $RR{$inf[7]}+=$inf[4];
            $Dp{$inf[7]}+=$inf[2];
            $count{$inf[7]}++;
        }
	}
    foreach my $dist (sort {$a<=>$b} keys %RR)
    {
        my $averR=$RR{$dist}/$count{$dist};
        my $averD=$Dp{$dist}/$count{$dist};
        print "$dist\t$count{$dist}\t$RR{$dist}\t$Dp{$dist}\t$averR\t$averD\n";
    }
close IA ;

#close OA ;
######################swimming in the sky and flying in the sea ###########################
