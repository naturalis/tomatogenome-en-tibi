#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

# transforms GFF columns into CSV for the SNP table in the database
while(<>) {
	chomp;
	s/SL2\.50ch0*//;
	my ( $chromo, $pos, $id, $ref, $alt ) = split /\t/, $_;
	my ( $hom, $het ) = split /,/, $alt;
    $het = '' if not $het;
	print join(',', $chromo, $pos, $ref, $hom, $het), "\n";
}

