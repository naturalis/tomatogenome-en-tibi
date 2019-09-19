#!/usr/bin/perl
open IN,$ARGV[0] or die "$!";
while(<IN>){
	chomp;
	split;
	my $aa="0000$_[1]";
	$aa=substr($aa,-3,3);
	print "$_[1]\t$aa\t$_[0]\t$_[0]\t$_[0]\t$_[0]\n";
}
close IN;
