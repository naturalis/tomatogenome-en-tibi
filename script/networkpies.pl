#!/usr/bin/perl
use strict;
use warnings;
use SVG;
use XML::Twig;
use Data::Dumper;
use Getopt::Long;
use Bio::Phylo::Util::Logger ':simple';

# process command line arguments
my $svg_file    = '../data/network/bases.phy.full.svg'; # produced by splitstree
my $meanq_file  = '../data/structure/structure.pruned.out.3.meanQ'; # produced by fastStructure
my $labels_file = '../data/structure/labels.txt'; # accession labels in same order as mapq_file
my @colors      = qw(#386CB0 #FFFF99 #BF5B17); # svg/html compatible color codes
my $verbosity   = WARN;
GetOptions(
    'svg_file=s'    => \$svg_file,
    'meanq_file=s'  => \$meanq_file,
    'labels_file=s' => \$labels_file,
    'colors=s'      => \@colors,
    'verbose+'      => \$verbosity,
);
Bio::Phylo::Util::Logger->new( '-level' => $verbosity, '-class' => 'main' );

# read the input file
my ( $twig, %nodes_for_labels ) = map_nodes_to_labels($svg_file);
my %pops_for_labels = map_admixture_to_labels($meanq_file,$labels_file);

# do the replacement
for my $label ( keys %pops_for_labels ) {
    INFO "drawing piechart for $label";
    draw_piechart( $pops_for_labels{$label}, \@colors, $nodes_for_labels{$label}->[0] );
}
$twig->print;

# arg: svg file, returns hash keyed on labels
# value: [ fill, stroke ] circle element
sub map_nodes_to_labels {
    my $svg_file = shift;
    INFO "Going to map node elements to accession labels in $svg_file";

    # going to collect the nodes with strokes or fills,
    # and the text labels (sans scale bar text)
    my ( @fill_circles, @stroke_circles, @labels );
    my $twig = XML::Twig->new();
    $twig->parsefile($svg_file);

    # collect the circle elements
    for my $circle ( $twig->descendants('circle') ) {
        INFO $circle;
        if ( $circle->att_exists('stroke') ) {
            push @stroke_circles, $circle;
        }
        else {
            push @fill_circles, $circle;
        }
    }

    # collect the text elements
    for my $text ( $twig->descendants('text') ) {
        my $label = $text->text;
        if ( $label !~ /^\d+\.\d+$/ ) {
            push @labels, $label;
            INFO $label;
        }
    }

    # build map
    my %map;
    for my $i ( 0 .. $#labels ) {
        $map{$labels[$i]} = [ $fill_circles[$i], $stroke_circles[$i] ];
    }
    return ( $twig, %map );
}

# args: *.meanQ file, poplabels file, returns hash keys on labels
# value: [ pop1 .. popN ] admixture
sub map_admixture_to_labels {
    my ( $meanq_file, $labels_file ) = @_;
    INFO "Going to map admixture from $meanq_file to accessions from $labels_file";

    # read the ordered list of labels
    my @labels;
    open my $lf, '<', $labels_file or die $!;
    while(<$lf>) {
        chomp;
        if ( /\S/ ) {
            push @labels, $_;
        }
    }

    # read the ordered list of populations
    my %map;
    my $i = 0;
    open my $mf, '<', $meanq_file or die $!;
    while(<$mf>) {
        chomp;
        if ( /\d+/ ) {
            my @record = split /\s+/, $_;
            $map{$labels[$i]} = \@record;
            $i++;
        }
    }
    return %map;
}

# args: [ pop1 .. popN ], [ color1 .. colorN ], circle element
sub draw_piechart {
    my ( $slices, $colors, $circle ) = @_;
    my ( $cx, $cy, $radius ) = ( $circle->att('cx'), $circle->att('cy'), $circle->att('r') );
    my @s     = @$slices;
    my $svg   = SVG->new;
    my $start = -90;
    my $PI    = 4 * atan2(1,1);
    my $pie   = $svg->tag( 'g', 'transform' => "translate($cx,$cy)" );
    for my $i ( 0 .. $#s ) {
        my $slice = $s[$i] * 360;
        my $color = $colors->[$i];
        my $do_arc  = 0;
        my $radians = $slice * $PI / 180;
        $do_arc++ if $slice > 180;
        my $ry     = $radius * sin($radians);
        my $rx     = $radius * cos($radians);
        my $g      = $pie->tag( 'g', 'transform' => "rotate($start)" );
        $g->path(
            'style' =>
              { 'fill' => "$color", 'stroke' => 'none' },
            'd' => "M $radius,0 A $radius,$radius 0 $do_arc,1 $rx,$ry L 0,0 z"
        );
        $start += $slice;
    }
    my $pie_twig = XML::Twig->new;
    $pie_twig->parse($svg->render);
    my $rendered = $pie_twig->root->first_child->sprint;
    INFO $rendered;
    $circle->set_outer_xml($rendered);
}