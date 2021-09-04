#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;
use Bio::EnTibiBases;
use Bio::Phylo::Util::Logger ':simple';

# process command line arguments
my $qfile;  # bases.str.3.meanQ
my $db;     # EnTibiBasesRemapped.db
my $labels; # labels.txt
my $verbosity = WARN;
GetOptions(
    'qfile=s'  => \$qfile,
    'dbfile=s' => \$db,
    'labels=s' => \$labels,
    'verbose+' => \$verbosity,
);

# instantiate services
my $schema = Bio::EnTibiBases->connect("dbi:SQLite:$db");
Bio::Phylo::Util::Logger->new( '-level' => $verbosity, '-class' => 'main' );

# key on label TS.\d+
my %acc;

# we want to have S. pimpinellifolium accessions with lat/lon coordinates
my $accessions = $schema->resultset('Accession')->search({
   'botanical_variety' => 'S. pimpinellifolium',
   'latitude'          => { '!=' => undef },
});
while( my $acc = $accessions->next ) {
    my $label = $acc->label;
    $acc{$label} = {
        'label' => $label,
        'lat'   => $acc->latitude,
        'lon'   => $acc->longitude,
    };
}

# read the labels file
my @labels;
{
    open my $fh, '<', $labels or die $!;
    while(<$fh>) {
        chomp;
        push @labels, $_ if /\S/;
    }
}

# read the meanQ file
my $i = 0;  
open my $fh, '<', $qfile or die $!;
while(<$fh>) {
    chomp;
    my $label = $labels[$i];
    if ( exists $acc{$label} ) {
        my ( $p1, $p2, $p3 ) = split /\s\s/, $_;
        $acc{$label}->{'p1'} = $p1;
        $acc{$label}->{'p2'} = $p2;
        $acc{$label}->{'p3'} = $p3;
    }
    $i++;
}

# print output
my @keys = qw(label lat lon p1 p2 p3);
print join("\t", @keys), "\n";
for my $label ( keys %acc ) {
    my @val = map { $acc{$label}->{$_} } @keys;
    print join("\t", @val), "\n";
}