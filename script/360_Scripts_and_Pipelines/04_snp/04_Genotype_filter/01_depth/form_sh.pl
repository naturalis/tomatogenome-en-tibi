#!/usr/bin/perl
use File::Basename;
my $list=shift;
my $soap_dir=shift;
open IN,$list or die "$!";
while(<IN>){
	chomp;
	my @inf=split;
	my $mark=(split(/\_/,$inf[2]))[0];
	print "$mark\n";
	my $out="W$mark.sh";
	mkdir  $mark unless (-d $mark);
	open OUT,">$out" or die  "$!";
	foreach my $sort (<$soap_dir/$mark/*.sort.gz>){
		my $chr=basename $sort;
		$chr=(split(/\./,$chr))[0];
		my $fa="/share/fg4/lintao/tomato/01_reference/$chr.fa";
#		print OUT "$sort\n";
		print OUT "/share/fg4/lintao/bin/Tools/iTools SOAPtools stat -InFile $sort -OutStat $mark/$chr.stat -Ref $fa -SiteD 3 > $mark/$chr.log\n";
	}
	close OUT;
	exit;
}
