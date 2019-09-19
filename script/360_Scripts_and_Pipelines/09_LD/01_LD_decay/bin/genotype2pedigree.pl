#!/usr/bin/perl
use strict;
use warnings;
#edit by heweiming 2009-10-23
die "Usage:<genotype data><ped output><info output>\nNOTE:This program only works for each chromosome, or in other words, you should not input a file with data from different chromosome, or different marker might have the same position\n" unless @ARGV == 3 ;
open IN, "$ARGV[0]"  || die "Can't open input file:$!\n";
open OT1, ">$ARGV[1]"|| die "Can't open output file1: $!\n"; ## The .ped file;
open OT2, ">$ARGV[2]"|| die "Can't open output file2: $!\n"; ## The .info file;

# my %iupac = ("M" => "AC", 
#             "K" => "GT",   
#			 "Y" => "CT",
#			 "R" => "AG", 
#			 "W" => "AT", 
#			 "S" => "CG",
#			 "A" => "AA",
#			 "T" => "TT",
#			 "C" => "CC",
#			 "G" => "GG",
#			 "-" => "--",
my %iupac = (
             "A" => "a a",
			 "C" => "c c",
			 "G" => "g g",
			 "T" => "t t",
             "M" => "a c", 
             "K" => "g t",   
			 "Y" => "c t",
			 "R" => "a g", 
			 "W" => "a t", 
			 "S" => "c g",
			 "-" => "- -",
			 "N" => "N N",
);

my @rows; ##Store each lines;
my $j = 0;
while (<IN>) { #begin with the second line;
    chomp;
	my @temp_array = split /\t/;
	my $chr        = $temp_array[0];
	my $pos        = $temp_array[1];  
	my @str_array  = split /\s+/, $temp_array[2];
	my $str        = join "\t", @str_array;
	foreach  (keys %iupac) {
		$str =~ s/$_/$iupac{$_}/g;
	}
	my %array = ('A' => 0, 'C' => 0, 'T' => 0, 'G' => 0,);
    $array{'A'} += $str =~ tr/a/A/;
	$array{'C'} += $str =~ tr/c/C/;
	$array{'T'} += $str =~ tr/t/T/;
	$array{'G'} += $str =~ tr/g/G/;
	my @keys;
	my @count;
	foreach  (sort { $array{$b} <=> $array{$a} } keys %array) {
		push @keys, $_;
		push @count, $array{$_};
	}
	next if ($count[2] != 0); ##there are three alleles;
	next if ($count[1] == 0); ##This is not SNP.  
	my $Major = sprintf "%.4f", $count[0] / ( $count[0] + $count[1] );
	my $Minor = sprintf "%.4f", $count[1] / ( $count[0] + $count[1] );
	
	$str =~ tr/A/1/;
	$str =~ tr/C/2/;
	$str =~ tr/G/3/;
	$str =~ tr/T/4/;
	$str =~ tr/-/0/;
	$str =~ tr/N/0/;


	if ($j == 0) { ## The first qualified line;
	    $j++;
		print OT2 "$j\t$pos\t$keys[0]\t$Major\t$keys[1]\t$Minor\n"; # Marker ID and its position;
        my @t   = split /\t/, $str; 
		my $num       = @t;
        for (my $i = 0; $i < $num ; $i++) {
	        my $k = $i+1;
	        $rows[$i] = "$k\t$k\t0\t0\t0\t0". "\t$t[$i]";
        }   
    }else{
	    $j++;
	    print OT2 "$j\t$pos\t$keys[0]\t$Major\t$keys[1]\t$Minor\n";
        my @t = split /\t/, $str;
		my $num       = @t;
        for (my $i = 0; $i < $num ; $i++) {
	        $rows[$i] .= "\t$t[$i]";
        }
	}
}

foreach  (@rows) {
	print OT1 "$_\n";
}

close IN;
close OT1;
close OT2;
