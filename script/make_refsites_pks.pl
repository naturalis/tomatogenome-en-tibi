#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use Getopt::Long;

# process command line arguments
my ( $infile, $outfile, $reffile, $accessions );
GetOptions(
    'infile=s'     => \$infile,
    'outfile=s'    => \$outfile,
    'reffile=s'    => \$reffile,
    'accessions=s' => \$accessions,
);

# make accession mapping
my %acc;
open my $acc, '<', $accessions or die $!;
while(<$acc>) {
    chomp;
    my ( $id, $label ) = split /\t/, $_;
    $acc{$label} = $id;
}

# start reading the snps file
my %refsites;
my $snp_id = 1;
my $ref_id = 1;
open my $in,  '<', $infile  or die $!;
open my $out, '>', $outfile or die $!;
open my $ref, '>', $reffile or die $!;
while(<$in>) {
    chomp;
    my @record = split /,/, $_;
    my $ref_coord = join ',', @record[0,1];
    my ( $altallele, $accession ) = @record[2,3];

    # add to the refsites if we haven't seen this yet
    if ( not $refsites{$ref_coord} ) {
        $refsites{$ref_coord} = $ref_id++;
        # pk, chromo, pos, allele
        print $ref join( ',', $refsites{$ref_coord}, ${ref_coord}  ), "\n";
    }

    # pk, fk_ref, fk_acc, allele
    $accession =~ s/-/./;
    my @snp = ( $snp_id++, $refsites{$ref_coord}, $acc{$accession}, $altallele );
    print $out join( ',', @snp ), "\n";
}