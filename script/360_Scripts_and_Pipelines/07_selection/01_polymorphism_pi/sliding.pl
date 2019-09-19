#!/usr/bin/perl -w
use strict;
#explanation:this program is edited to 
#edit by liuxin;   Thu Apr 28 18:41:11 CST 2011
#Version 1.0    liuxin@genomics.org.cn 

die  "Version 1.0\t2011-04-28;\nUsage: $0 <InPut><Out>\n" unless (@ARGV ==3);

#############Befor  Start  , open the files ####################


my $len=$ARGV[1];
my $outfile=$ARGV[2];
#open (OA,">$ARGV[1]") || die "output file can't open $!";

################ Do what you want to do #######################

for(my $i=0;$i*10000<$len;$i++)
{
    my $tmp=$i+10;
    my $tmp2=$i*10000;
    `cat $ARGV[0] |awk '\$2>$i*10000 && \$2<$tmp*10000' >t.genotype`;
    `perl /share/fg3/lintao/solab/lintao/tomato/08_selection/fresh_process/work/change_genotype2.pl t.genotype $tmp2`;
    `perl /share/fg3/lintao/solab/lintao/tomato/08_selection/fresh_process/work/count_pop_statistics.pl >>$outfile`;
}


#close OA ;

######################swimming in the sky and flying in the sea ###########################
