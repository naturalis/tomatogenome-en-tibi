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
    next if /accession_id/; # skip header
    # chromosome,position,refallele,altallele_hom,altallele_het,accession_id
    my ($chromo,$pos,$ref_allele,$hom,$het,$acc_id) = split /,/, $_;
    my $ref_coord = "${chromo},${pos}";

    # add to the refsites if we haven't seen this yet
    if ( not $refsites{$ref_coord} ) {
        $refsites{$ref_coord} = $ref_id++;
        # pk, chromo, pos, allele
        print $ref join( ',', $refsites{$ref_coord}, ${ref_coord}, $ref_allele  ), "\n";
    }

    # pk, fk_ref, fk_acc, hom_allele, het_allele
    $acc_id =~ s/-/./;
    my @snp = ( $snp_id++, $refsites{$ref_coord}, $acc{$acc_id}, $hom, ( $het || '' )  );
    print $out join( ',', @snp ), "\n";
}