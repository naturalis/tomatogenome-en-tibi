#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Bio::EnTibiBases;
use Bio::Phylo::Util::Logger ':simple';

my $LABEL = 4;
my $START = 6;

# process command line arguments
my $bases; # bases.str
my $db;    # EnTibiBasesRemapped.db
my $verbosity = WARN;
GetOptions(
    'bases=s'  => \$bases,
    'verbose+' => \$verbosity,
    'db=s'     => \$db,
);

# instantiate services
my $schema = Bio::EnTibiBases->connect("dbi:SQLite:$db");
Bio::Phylo::Util::Logger->new( '-level' => $verbosity, '-class' => 'main' );

# keyed on label
my ( %data, $length );

# start reading data
INFO "Going to read $bases";
open my $fh, '<', $bases or die $!;
while(<$fh>) {
    chomp;
    next unless /lyco|pimp|Tibi/;
    my @data  = split /\t/, $_;
    my $label = $data[ $LABEL ];
    my @bases = @data[ $START .. $#data ];
    if ( not $data{$label} ) {
        $data{$label} = [];
    }
    push @{ $data{$label} }, \@bases;
    $length = $#bases;
    INFO "Sites: $length";
}

my %hohe;
LOCUS: for my $i ( 0 .. $length ) {
    
    my %seen;
    for my $label ( keys %data ) {
        my $b = $data{$label}->[0]->[$i];
        $seen{$b}++;
    }
#    my ($lowest) = sort { $a <=> $b } values %seen;
#    if ( $lowest == 1 ) {
#        INFO "Skipping autapomorphy at site $i";
#        next LOCUS;
#    }
    
    my ($refb) = sort { $seen{$b} <=> $seen{$a} } keys %seen;
    for my $label ( keys %data ) {
        if ( not $hohe{$label} ) {
            $hohe{$label} = {
                'ref' => 0,
                'hom' => 0,
                'het' => 0,
            };
        }
        my $b1 = $data{$label}->[0]->[$i];
        my $b2 = $data{$label}->[1]->[$i];
        #INFO "$refb $b1 $b2";
        if ( $b1 eq $refb and $b2 eq $refb ) {
            $hohe{$label}->{'ref'}++;
        }
        elsif ( $b1 ne $refb and $b1 eq $b2 ) {
            $hohe{$label}->{'hom'}++;
        }
        elsif ( $b1 ne $refb and $b1 ne $b2 ) {
            $hohe{$label}->{'het'}++;
        }        
    }
    
}

print join("\t", qw(label ref hom het botanical_variety status country)), "\n";
for my $label ( keys %hohe ) {
    
    my @val = ( $label );
    push @val, $hohe{$label}->{'ref'};
    push @val, $hohe{$label}->{'hom'};
    push @val, $hohe{$label}->{'het'};
    
    my $acc = $schema->resultset('Accession')->search({ 'label' => $label })->single;
    push @val, $acc->botanical_variety;
    push @val, $acc->status;
    push @val, $acc->country;
    
    print join("\t", @val), "\n";
}