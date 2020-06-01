#!/usr/bin/perl
use strict;
use warnings;
use SVG;
use XML::Twig;
use Data::Dumper;
use Getopt::Long;
use Graphics::Color;
use Graphics::Color::HSV;
use List::Util 'shuffle';
use Bio::Phylo::Util::Logger ':simple';

my @popcolors = ( 'gray', 'black', 'white' );

my %color_for_state = (
    'Brazil'     => '#2b5797',
    'Chile'      => '#9f00a7',
    'Ecuador'    => '#99b433',
    'Honduras'   => '#ee1111',
    'Mexico'     => '#da532c',
    'Peru'       => '#1e7145',
    'Unknown'    => 'gray',
    'Bolivia'    => '#603cba',
    'Colombia'   => '#00aba9',
    'Costa Rica' => '#b91d47',
    'Guatemala'  => '#e3a21a',
    'El Salvador'=> '#ffc40d',
);
# colors from https://www.w3schools.com/colors/colors_metro.asp
# respective colors: Dark blue, Light purple, Light green, red, dark orange, dark green,
#		     gray, dark purple, teal, dark red, orange, and yellow.

# process command line arguments
my $svg_file        = '../../network/bases.phy.zoom.circles.svg'; # produced by splitstree
my $meanq_file      = '../../structure/structure.new.out.3.meanQ'; # produced by fastStructure
my $labels_file     = '../../network/labels_new.txt'; # accession labels in same order as mapq_file
my $accessions_file = '../../network/accessions_new.tsv'; # accession metadata
my $column          = 'country'; # metadata column in the accessions table
my $verbosity       = WARN;
GetOptions(
    'svg_file=s'    => \$svg_file,
    'meanq_file=s'  => \$meanq_file,
    'labels_file=s' => \$labels_file,
    'verbose+'      => \$verbosity,
);
Bio::Phylo::Util::Logger->new( '-level' => $verbosity, '-class' => 'main' );

# read the input files
my %cultivars_for_labels = map_states_to_labels($accessions_file, 'botanical_variety');
my ( $twig, %nodes_for_labels ) = map_nodes_to_labels($svg_file, %cultivars_for_labels);
my %pops_for_labels = map_admixture_to_labels($meanq_file,$labels_file);
my %states_for_labels = map_states_to_labels($accessions_file, $column);

# do the replacements
for my $label ( keys %pops_for_labels ) {
    INFO "drawing piechart for $label";
    draw_piechart( $pops_for_labels{$label}, \@popcolors, $nodes_for_labels{$label}->[0] );

    INFO "draw stroke color for $label";
    my $state = $states_for_labels{$label};
    my $color = $color_for_state{$state};
    $nodes_for_labels{$label}->[1]->set_att('stroke' => $color, 'fill' => 'none', 'stroke-width' => 8 );
}
$twig->print;

# reads accessions table, extracts $column value for each label
sub map_states_to_labels {
    my ( $file, $column ) = @_;
    my ( %map, @header );
    open my $in, '<', $file or die $!;
    LINE: while(<$in>) {
        chomp;
        my @record = split /\t/, $_;
        if ( not @header ) {
            @header = @record;
            next LINE;
        }
        else {
            my %record = map { $header[$_] => $record[$_] } 0 .. $#header;
            my ( $label, $value ) = @record{'label',$column};
            $map{$label} = $value;
        }
    }
    return %map;
}

# arg: svg file, returns hash keyed on labels
# value: [ fill, stroke ] circle element
sub map_nodes_to_labels {
    my ( $svg_file, %cultivars ) = @_;
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
            if ( $cultivars{$label} =~ /pimp/ ) {
                $label =~ s/TS/P/;
            }
            elsif ( $cultivars{$label} =~ /cera/ ) {
                $label =~ s/TS/C/;
            }
            elsif ( $cultivars{$label} =~ /cum$/ ) {
                $label =~ s/TS/B/;
            }
            $text->set_text($label);
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

sub make_palettes {
    my ( $h1, $h2 ) = @_;
    my ($v1) = values %$h1;
    my %vals2 = map { $_ => 1 } values %$h2;
    my $n1 = scalar(@$v1);
    my $n2 = scalar(keys(%vals2));
    my @palette = shuffle make_colors($n1+$n2);
    my @p1 = @palette[0..$n1-1];
    my @p2 = @palette[$n1..$#palette];
    return \@p1, \@p2;
}

sub make_colors {
    my $n = shift;
    my $step = 360/$n;
    my @rgbs;
    for my $i ( 1 .. $n ) {
        push @rgbs, Graphics::Color::HSV->new({
            hue         => $i * $step,
            saturation  => 1,
            value       => .7,
        })->to_rgb->as_hex_string('#');
    }
    return @rgbs;
}
