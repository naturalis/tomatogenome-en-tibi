#!/usr/bin/perl
use strict;
die usage() if @ARGV == 0;
my ($LD_output,$window_size,$LD_decay_output) = @ARGV;

my %hash_window_sum_R_square;
my %hash_window_pair_number;


open NEW,"$ARGV[0]" or die;
while(<NEW>){
	chomp;
	next if (/LOD/);
	my @array = split /\s+/;
	my $coordinate = int($array[-2]/100);
	$hash_window_sum_R_square{$coordinate} += $array[4];
	$hash_window_pair_number{$coordinate} ++;
}
close NEW;	


open NEW1,">$LD_decay_output" or die;
print NEW1 "LD_decay_distance(kb)\tAverage_R_square\n";
foreach my $key(sort {$a <=> $b} keys %hash_window_pair_number){
        my $value = $hash_window_sum_R_square{$key}/$hash_window_pair_number{$key};
        my $distance = ($key*$window_size)/1000;
        print NEW1 "$distance\t$value\n";
}
close NEW1;

sub usage{
	my $die =<<DIE;
	usage : perl *.pl *.LD_output window_size LD_decay_output
DIE
}
