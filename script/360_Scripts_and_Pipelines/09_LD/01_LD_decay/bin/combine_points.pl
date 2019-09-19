#!/usr/bin/perl-w
use strict;
#explanation:this program is edited to 
#edit by LIUXin;   Fri Jan 28 10:31:20 CST 2011
#Version 1.0    liuxin@genomics.org.cn 

die  "Version 1.0\t2011-01-28;\nUsage: $0 <decay_info><Number of points to combine>\n" unless (@ARGV == 2);

open IN,"$ARGV[0]"  || die "Input file can't open $!";
#open OT,">$ARGV[1]" || die "Output file can't open $!";
my $to_combine=$ARGV[1];

my ($total,$number,$dist);

while(<IN>) 
{ 
	chomp; 
	my @line=split;
    if($line[0]<=10)
    {
        print "$line[0]\t$line[4]\n";
    }
    else
    {
        if($number<$to_combine)
        {
            $total+=$line[4];
            $number++;
            $dist=$line[0] if $number==int($to_combine/2);
        }
        else
        {
            $total+=$line[4];
            my $averR=$total/$number;
            $total=0;
            $number=1;
            print "$dist\t$averR\n";
        }
    }
}


close IN;
