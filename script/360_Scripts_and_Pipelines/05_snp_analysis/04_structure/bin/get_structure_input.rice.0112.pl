#/usr/bin/perl
use strict;
use warnings;

## This program is to transform individual genotype data to a standard input file for the software "structure".
##Input file for this program is the genotype file for 50 Tibetans(all 22 auto chromosomes), if "genotype data with chimp" is used, it's OK, sequences beyond 50 are disgarded. 
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
#);

## Transform ATGC to 1234 and "-" to "-9" respectively. A->1 , T->2, C->3, G->4, - -> -9;
die "Usage:<input><output>" unless @ARGV == 2 ;
my %iupac = (
             "M" => [1,3],
			 "K" => [4,2],
			 "Y" => [3,2],
			 "R" => [1,4],
			 "W" => [1,2],
			 "S" => [3,4],
			 "A" => [1,1],
			 "T" => [2,2],
			 "C" => [3,3],
			 "G" => [4,4],
			 "-" => [-9,-9],
);

open IN, "$ARGV[0]"   || die "Can't open input file: $!\n";
open OUT, ">$ARGV[1]" || die "Can't open output file: $!\n";
#Store each line in an array, the first line is the distance between the two loci;
my @name_list = qw (12883_AUS
45975_AUS
6307_AUS
8555_AUS
27762_IND
26872_IND
30416_IND
43545_IND
51250_IND
51300_IND
8231_IND
9148_IND
9177_IND
1107_TEJ
27630_TEJ
32399_TEJ
2540_TEJ
418_TEJ
55471_TEJ
8191_TEJ
NP_TEJ
11010_TRJ
17757_TRJ
25901_TRJ
328_TRJ
38698_TRJ
43325_TRJ
43397_TRJ
43675_TRJ
50448_TRJ
66756_TRJ
8244_TRJ
12793_ARO
38994_ARO
9060_ARO
9062_ARO
RA4952_ARO
31856_V
60542_IV
6513_III
R_105426
R_105912
R_105958
R_105960
R_106161
R_106505
R_80506
R_81982
R_81991
R_DX
R_Nepal
R_P25
R_P46
R_P61
R_YJ
N_103407
N_105327
N_105705
N_105784
N_105879
N_106105
N_106154
N_106345
N_80470
N_89215
);
my @all_rows;
$all_rows[0] = "  -1";
for (my $i=1; $i<=65 ; $i++) {
	$all_rows[$i] = ["$name_list[$i-1]", "$name_list[$i-1]",]; 
}

my $pre_chr = '';
my $pre_position;
while (<IN>) {
	chomp;
	next unless $_; #if an empty line is input, skip it;
	my @temp_line = split;
	$pre_chr  = $temp_line[0] unless $pre_chr; #For the first line, give $pre_chr a value;
	
	if ($temp_line[0] ne $pre_chr) {
		$all_rows[0] .= " -1";
		$pre_chr      = $temp_line[0]; #store the previous chr name;
		$pre_position = $temp_line[1]; # store the previous position;
	}elsif($pre_position){ #From the second time we read in a line, it goes this way.
        my $distance = $temp_line[1] - $pre_position; 
		$all_rows[0] .= " $distance";
	}else{
		$pre_position = $temp_line[1]; # store the position in order to calculate distrance between two adjacent loci;
	}

	for (my $i = 2; $i <= 66 ; $i++) {
		$all_rows[$i-1]->[0] .= " $iupac{$temp_line[$i]}->[0]"; 
		$all_rows[$i-1]->[1] .= " $iupac{$temp_line[$i]}->[1]";
	}
    
}

my $count = @all_rows;
print OUT "$all_rows[0]\n";
for (my $j=1; $j<$count; $j++) {
	print OUT "$all_rows[$j]->[0]\n";
	print OUT "$all_rows[$j]->[1]\n";
}

close IN;
close OUT;
