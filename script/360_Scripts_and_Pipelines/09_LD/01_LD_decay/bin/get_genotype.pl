#!/usr/bin/perl-w
use strict;
#explanation:this program is edited to 
#edit by LIUXin;   Tue Mar 29 13:53:36 CST 2011
#Version 1.0    liuxin@genomics.org.cn 

die  "Version 1.0\t2011-03-29;\nUsage: $0 <InPut>\n" unless (@ARGV == 2);

open LI,"$ARGV[0]"  || die "Input file can't open $!";
open GN,"$ARGV[1]" || die "Output file can't open $!";

my @ind;

while(<LI>)
{ 
	chomp; 
	my @line=split;
    $line[0]++;
    push(@ind,$line[0]);
}

while(<GN>)
{
    chomp;
    my @line=split;
    print "$line[0]\t$line[1]\t";
    for(my $i=0;$i<@ind;$i++)
    {
        print "$line[$ind[$i]] ";
    }
    print "\n";
}

close LI;
close GN;
