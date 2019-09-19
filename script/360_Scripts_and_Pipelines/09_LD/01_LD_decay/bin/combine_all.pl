#!/usr/bin/perl-w
use strict;
#explanation:this program is edited to 
#edit by LIUXin;   Fri Jan 28 10:48:01 CST 2011
#Version 1.0    liuxin@genomics.org.cn 

die  "Version 1.0\t2011-01-28;\nUsage: $0 <InPut List of chromosomal R2 and D'>\n" unless (@ARGV == 1);

open IN,"$ARGV[0]"  || die "Input file can't open $!";
#open OT,">$ARGV[1]" || die "Output file can't open $!";

my (%count,%Rsquare,%Dprime);

while(<IN>)
{ 
	chomp;
	open Rs,"$_" or die "$!";
	<Rs>;
	while(<Rs>)
	{
		my @line=split;
		my $dist=$line[0];
		$count{$dist}+=$line[1];
		$Rsquare{$dist}+=$line[2];
		$Dprime{$dist}+=$line[3];
	}
}

foreach my $dist (sort {$a<=>$b} keys %count)
{
	my $averR=$Rsquare{$dist}/$count{$dist};
	my $averD=$Dprime{$dist}/$count{$dist};
	print "$dist\t$count{$dist}\t$Rsquare{$dist}\t$Dprime{$dist}\t$averR\t$averD\n";
}

close IN;
