#!/usr/bin/perl
use File::Basename;
open IN,$ARGV[0] or die  "$!";

my $file_name=basename $ARGV[0];
my @file_name=split(/\//,$ARGV[0]);
my $chr=(split(/\./,$file_name))[0];

my $out="$file_name[-2]/$chr.fst.overall";
open OUT,">$out" or die  "$!";
while(<IN>){
    chomp;
    my @f=split;
    if($#f==0){
        print OUT "$chr\t$f[0]\t";
    }
    if($f[0] eq "\"Fst\""){
        print OUT  "$f[1]\n";
    }
}
close IN;
close OUT;
