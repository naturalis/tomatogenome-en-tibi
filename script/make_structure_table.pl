#!/usr/bin/perl
use strict;
use warnings;
use PDL;
use PDL::Matrix;
use Getopt::Long;
use Bio::EnTibiBases;
use Bio::Phylo::Util::Logger ':simple';

my %map = (
    'A' => 0,
    'C' => 1,
    'G' => 2,
    'T' => 3
);

my %rev = (
    '0' => 'A',
    '1' => 'C',
    '2' => 'G',
    '3' => 'T',
);

my %iupac = (
    'AC'   => 'M',
    'AG'   => 'R',
    'AT'   => 'W',
    'CG'   => 'S',
    'CT'   => 'Y',
    'GT'   => 'K',
);

# process command line arguments
my $db = $ENV{'HOME'} . '/Dropbox/documents/projects/dropbox-projects/tomatogenome-en-tibi/data/snps_bases.db';
my $verbosity = WARN;
my @fields    = qw(label botanical_variety status country latitude longitude);
my $outformat = 'structure';
GetOptions(
    'db=s'        => \$db,
    'verbose+'    => \$verbosity,
    'fields=s'    => \@fields,
    'outformat=s' => \$outformat,
);

# instantiate services
my $schema = Bio::EnTibiBases->connect("dbi:SQLite:$db");
Bio::Phylo::Util::Logger->new( '-level' => $verbosity, '-class' => 'main' );

# instantiate matrix
my $nrows = $schema->resultset('Accession')->count;     # number of accessions
my $ncols = $schema->resultset('Refsite')->count;       # number of sites
my $matrix = PDL::Matrix->zeroes( $nrows * 2, $ncols ); # matrix has double the rows: interleaved major/minor allele

my $col = 0;
my $sites = $schema->resultset('Refsite');
while ( my $site = $sites->next ) {

    # fill the actually seen SNPs: so here we iterate over the accessions that actually vary from the reference
    my %seen;
    for my $snp ( $site->snps ) {

        # accession IDs are one based, which we convert to zero-based indices by subtracting one,
        # then converting to interleaved by multiplying by two, i.e. 1=>0, 2=>2, 3=>4, 4=>6 etc.
        my $row = ( $snp->accession_id - 1 ) * 2;
        $seen{$row}++;
        my $hom = $map{ uc $snp->altallele_hom };
        my $het = $map{ uc $snp->altallele_het };
        $matrix->set( $row, $col, $hom );
        $matrix->set( $row + 1, $col, $het || $hom ); # use major/hom allele if there is no het
    }

    # fill the rest with this, i.e. the reference allele
    my $ref = $map{ uc $site->refallele };

    # if there are 3 rows, then the highest index we want to visit is 3*2-2=4
    for ( my $i = 0; $i <= ( ( $nrows * 2 ) - 1 ); $i += 2 ) {
        next if $seen{$i};
        $matrix->set( $i, $col, $ref );
        $matrix->set( $i + 1, $col, $ref );
    }

    $col++;
    INFO $col unless $col % 1000;
}

# to store the indices of sites that have variation
my @variant_sites;

# the number of rows in the interleaved matrix is $nrows * 2, which we convert to
# the zero-based index of the last row by subtracting 1.
my $row_slice = '0:' . ( ( $nrows * 2 ) - 1 );
for my $i ( 0 .. $ncols - 1 ) {
    my %alleles = map { $_ => 1 } list $matrix->slice( $row_slice, $i );

    # BTW we want to keep autapomorphies because they will factor into the pairwise
    # distance calculations
    if ( scalar(keys(%alleles)) > 1 ) {
        push @variant_sites, $i;
    }
}

# print the matrix
if ( $outformat =~ /^str/ ) {

    my @acc = $schema->resultset('Accession')->all;
    for ( my $i = 0; $i <= ( ( $nrows * 2 ) - 1 ); $i += 2 ) {

        # print main allele row
        my @meta = map {$acc[$i/2]->$_ || 'NA'} @fields;
        s/\s+/_/g for @meta;
        print join "\t", @meta;
        print "\t";
        my @hom = list $matrix->slice($i);
        print join "\t", map {$rev{$_}} @hom[@variant_sites];
        print "\n";

        # print minor allele row
        print join "\t", @meta;
        print "\t";
        my @het = list $matrix->slice($i + 1);
        print join "\t", map {$rev{$_}} @het[@variant_sites];
        print "\n";
        INFO $i/2;
    }
}
else {
    my @acc = $schema->resultset('Accession')->all;

    # PHYLIP header: ntax nchar
    print scalar(@acc), ' ', scalar(@variant_sites), "\n";
    for ( my $i = 0; $i <= ( ( $nrows * 2 ) - 1 ); $i += 2 ) {

        # index PHYLIP rows on label, pad to length 10
        my $label = $acc[$i/2]->label;
        $label .= ( ' ' x ( 10 - length($label) ) );

        # merge @hom and @het as IUPAC single character ambiguity codes
        my @hom = list $matrix->slice($i);
        my @het = list $matrix->slice($i + 1);
        my @hom_bases = map {$rev{$_}} @hom[@variant_sites];
        my @het_bases = map {$rev{$_}} @het[@variant_sites];
        my @merged;
        for my $j ( 0 .. $#hom_bases ) {
            if ( $hom_bases[$j] eq $het_bases[$j] ) {
                push @merged, $hom_bases[$j];
            }
            else {
                my $bases = join '', sort { $a cmp $b } $hom_bases[$j], $het_bases[$j];
                push @merged, $iupac{$bases};
            }
        }

        # print row
        print $label, join('', @merged), "\n";
        INFO $i/2;
    }
}