#!/usr/bin/perl
use strict;
die usage() if @ARGV == 0;
my ($window_size,$LD_decay_output_file) = @ARGV;

my @files = <./LDOUT/chr*/*.LD.gz>;

my %hash_window_sum_R_square;
my %hash_window_pair_number;

foreach my $file(@files){
        print "Reading file:$file\n";
        open NEW,"zcat $file |" or die;
        while(<NEW>){
                chomp;
                next if (/LOD/);
                my @array = split /\s+/;
                my $coordinate = int($array[-2]/100);
                $hash_window_sum_R_square{$coordinate} += $array[4];
                $hash_window_pair_number{$coordinate} ++;
        }
        close NEW;
}

open NEW1,">$LD_decay_output_file" or die;
print NEW1 "LD_decay_distance(kb)\tAverage_R_square\n";
foreach my $key(sort {$a <=> $b} keys %hash_window_pair_number){
        my $value = $hash_window_sum_R_square{$key}/$hash_window_pair_number{$key};
        my $distance = ($key*$window_size)/1000;
        print NEW1 "$distance\t$value\n";
}
close NEW1;

sub usage{
        my $die =<<DIE;
        usage : perl *.pl window_size LD_decay_file_whole_genome
DIE
}
    
