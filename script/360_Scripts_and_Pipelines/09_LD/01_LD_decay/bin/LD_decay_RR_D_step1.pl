#!/usr/bin/perl
use strict;
use warnings;
#  Edit   by HeWeiming  
#  2009-10-22
die "Usage:<input of LD result><input of info with MAF><bin size><output for matched><output for unmatched><simulated length>" unless @ARGV == 6 ;
open OA, ">$ARGV[3]" || die "Can't open output file A: $!\n"; ## Store matched pairs;
open OB, ">$ARGV[4]" || die "Can't open output file B: $!\n"; ## Store unmatched pairs;
###################################
my $bin_size = $ARGV[2];
my $length   = $ARGV[5];
my $bin_num  = $length/ $bin_size;
my @interval;
my %r2_sum_matched;
my %count_matched;
my %r2_sum_unmatched;
my %count_unmatched;
my %D_sum_matched ;
my %D_sum_unmatched;

###################################
open IA, "$ARGV[0]"    || die "Can't open input file A : $!\n";
open IB, "$ARGV[1]"    || die "Can't open input file B : $!\n";
my %hash_maf;


while (<IB>)
{ ##Store the maf for each site;
	chomp;
	my @temp_maf = split;
	$hash_maf{$temp_maf[0]} = $temp_maf[5];
}

###################################

my $header = <IA>; #skip head line;

while (<IA>) 
{
	chomp;
	my @temp = split;
	next if ($temp[7] > $length);
     my $i=int (($temp[7]-0.888)/$bin_size);  
#     my $i=int($aa);
#    if($i==$aa) {$i--;}
	if ( $hash_maf{$temp[0]} == $hash_maf{$temp[1]} )
    { ##Matched!
                $r2_sum_matched{$i} += $temp[4];
                $D_sum_matched{$i} += $temp[2];
				$count_matched{$i}++;
	}
    else
    {## Unmatched!!
                $r2_sum_unmatched{$i} += $temp[4];
                $D_sum_unmatched{$i} += $temp[2];
				$count_unmatched{$i}++;
	}
}

close IA;
close IB;

foreach  (sort {$a <=> $b} keys %r2_sum_matched) 
{
	my $meanr = $r2_sum_matched{$_} / $count_matched{$_};
    my $meanD = $D_sum_matched{$_} / $count_matched{$_};
    print OA "$_\t$count_matched{$_}\t$r2_sum_matched{$_}\t $D_sum_matched{$_}\t$meanr\t$meanD\n";
    
}
close OA;

foreach  (sort {$a <=> $b} keys %r2_sum_unmatched) 
{
	my $meanr = $r2_sum_unmatched{$_} / $count_unmatched{$_};
	my $meanD = $D_sum_unmatched{$_} / $count_unmatched{$_};
   print OB "$_\t$count_unmatched{$_}\t $r2_sum_unmatched{$_}\t $D_sum_unmatched{$_}\t $meanr\t$meanD\n";   
}
close OB;
