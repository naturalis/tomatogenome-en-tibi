#!/usr/bin/perl -w
use strict;
use warnings;
use FileHandle;

die "Version 1.0\t2010-09-9;\nUsage: $0 <chr.list><info.out><OutDir><Soap><Single>\n" unless (@ARGV ==4 ||@ARGV ==5);

my @input =();
$input[0]=$ARGV[3]; 
$input[1]=$ARGV[4] if ($#ARGV==4);
chomp @input;
$input[0] =~ /([^\/]+)$/;
my $out = "$1.insert";
my $lane= "$1";

my $total_map_reads = 0;
my $total_single = 0;
my $total_repeat_pair = 0;
my $total_uniq_pair = 0;
my $total_uniq_low_pair = 0;
my $total_uniq_normal_pair = 0;

my %insert;
my $insert;

my $length1=0;
my $length2;

my %fh=();

open (Info,">$ARGV[1]")  || die "input file can't open $!" ;
open (Chr,"<$ARGV[0]")   || die "input file can't open $!" ;

my $Read_id=1;
while(<Chr>)
{
    chomp ;
    my @inf=split  ;
    my $chr=$inf[0];
    my $outputfile="$ARGV[2]/$chr";
    $fh{$chr}=FileHandle->new(">$outputfile");
}
close Chr ;

############ swimming in the sky and filying in the sea #########
foreach my $input (@input) {
    open (IN, "<$input" ) or die "$!" ;
    my @path=split (/\//,$input);
    print Info "#$path[-1]\n";
    my $all_read=0;   my $uniq_read=0 ;
    my $all_Depth=0 ; my $uniq_Depth=0;
    my %Read_chr=();   my %Depth_chr=();
    my %Read_uniq_chr=();   my %Depth_Uniq_chr=();
    my %MisMatch=();

    while (<IN>) {
        $total_map_reads+=2;
        my $line1 = $_;
        my ($id1, $n1, $len1, $f1, $chr1, $x1, $m1) = (split "\t", $line1)[0,3,5,6,7,8,-2];
        if (eof IN) {
            my @inf=split(/\t/,$line1);
            $inf[0]=$Read_id ;
            $Read_id++;
            $line1=join("\t",@inf);
            $total_map_reads--;
            $fh{$chr1}->print($line1);
            $all_Depth+=$len1 ; $all_read++; 
            $Read_chr{$chr1}++; $Depth_chr{$chr1}+=$len1 ;
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/A/A/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/T/T/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/C/C/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/G/G/g);

            if ($n1==1)
            { 
                $uniq_read++;
                $uniq_Depth+=$len1;
                $Read_uniq_chr{$chr1}++;
                $Depth_Uniq_chr{$chr1}+=$len1;
            }
            last;
        }
        my $line2 = <IN> ;
        my ($id2, $n2, $len2, $f2, $chr2, $x2, $m2) = (split "\t", $line2)[0,3,5,6,7,8,-2];

        if($len1 > $length1)
        {
            $length1=$len1;
        }
        $id1 =~ s/\/[12]$//;
        $id2 =~ s/\/[12]$//;

        if ($id1 ne $id2){ #single
            seek (IN, -length($line2),1);
            $total_map_reads--;
            
            my @inf=split(/\t/,$line1);
            $inf[0]=$Read_id ;
            $Read_id++;
            $line1=join("\t",@inf);

            $fh{$chr1}->print($line1);
            $all_Depth+=$len1 ; $all_read++; 
            $Read_chr{$chr1}++; $Depth_chr{$chr1}+=$len1 ;
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/A/A/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/T/T/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/C/C/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/G/G/g);

            if ($n1==1)
            { 
                $uniq_read++;
                $uniq_Depth+=$len1;
                $Read_uniq_chr{$chr1}++;
                $Depth_Uniq_chr{$chr1}+=$len1;
            }
        }
#		elsif ($m1 ne "${len1}M" or $m2 ne "${len2}M") { #trim
        elsif ($chr1 ne $chr2) { #single
            my @inf=split(/\t/,$line1);
            $inf[0]=$Read_id ;
            $line1=join("\t",@inf);
            my @inff=split(/\t/,$line2);
            $inff[0]=$Read_id ;
            $Read_id++;
            $line2=join("\t",@inff);

            $fh{$chr1}->print($line1);
            $fh{$chr2}->print($line2);
            $all_Depth+=($len1+$len2); $all_read+=2;
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/A/A/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/T/T/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/C/C/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/G/G/g);

            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/A/A/g);
            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/T/T/g);
            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/C/C/g);
            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/G/G/g);


           $Read_chr{$chr1}++; $Depth_chr{$chr1}+=$len1 ;
            if ($n1==1)
            { 
                $uniq_read++;
                $uniq_Depth+=$len1;
                $Read_uniq_chr{$chr1}++;
                $Depth_Uniq_chr{$chr1}+=$len1;
            }
            $Read_chr{$chr2}++; $Depth_chr{$chr2}+=$len2 ;

            if  ($n2==1)
            { 
                $uniq_read++;
                $uniq_Depth+=$len2;
                $Read_uniq_chr{$chr2}++;
                $Depth_Uniq_chr{$chr2}+=$len2;
            }
        }
        elsif ($n1!=1 or $n2!=1) { #repeat
            my @inf=split(/\t/,$line1);
            $inf[0]=$Read_id ;
            $line1=join("\t",@inf);
            my @inff=split(/\t/,$line2);
            $inff[0]=$Read_id ;
            $Read_id++;
            $line2=join("\t",@inff);
           $total_repeat_pair++;
            $fh{$chr1}->print($line1);
            $fh{$chr2}->print($line2);
            $all_Depth+=($len1+$len2) ; $all_read+=2;
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/A/A/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/T/T/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/C/C/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/G/G/g);

            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/A/A/g);
            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/T/T/g);
            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/C/C/g);
            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/G/G/g);

           $Read_chr{$chr1}++; $Depth_chr{$chr1}+=$len1 ;
            if  ($n1==1)
            { 
                $uniq_read++;
                $uniq_Depth+=$len1;
                $Read_uniq_chr{$chr1}++;
                $Depth_Uniq_chr{$chr1}+=$len1;
            }
            $Read_chr{$chr2}++; $Depth_chr{$chr2}+=$len2 ;
            if  ($n2==1)
            { 
                $uniq_read++;
                $uniq_Depth+=$len2;
                $Read_uniq_chr{$chr2}++;
                $Depth_Uniq_chr{$chr2}+=$len2;
            }

        }
        elsif ($f1 eq '+' && $f2 eq '-') {
#			$insert = abs($x2 - $x1 + $len2);
             my @inf=split(/\t/,$line1);
            $inf[0]=$Read_id ;
            $line1=join("\t",@inf);
            my @inff=split(/\t/,$line2);
            $inff[0]=$Read_id ;
            $Read_id++;
            $line2=join("\t",@inff);
           $insert = $x2 - $x1 + $len2;
            $insert{$insert}++;
            $fh{$chr1}->print($line1);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/A/A/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/T/T/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/C/C/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/G/G/g);

            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/A/A/g);
            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/T/T/g);
            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/C/C/g);
            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/G/G/g);

           $fh{$chr2}->print($line2);
            $all_Depth+=($len1+$len2) ; $all_read+=2;
            $Read_chr{$chr1}++; $Depth_chr{$chr1}+=$len1 ;
            if  ($n1==1)
            { 
                $uniq_read++;
                $uniq_Depth+=$len1;
                $Read_uniq_chr{$chr1}++;
                $Depth_Uniq_chr{$chr1}+=$len1;
            }
            $Read_chr{$chr2}++; $Depth_chr{$chr2}+=$len2 ;
            if  ($n2==1)
            { 
                $uniq_read++;
                $uniq_Depth+=$len2;
                $Read_uniq_chr{$chr2}++;
                $Depth_Uniq_chr{$chr2}+=$len2;
            }
        }
        elsif ($f2 eq '+' && $f1 eq '-') {
#			$insert = abs($x1 - $x2 + $len1);
              my @inf=split(/\t/,$line1);
            $inf[0]=$Read_id ;
            $line1=join("\t",@inf);
            my @inff=split(/\t/,$line2);
            $inff[0]=$Read_id ;
            $Read_id++;
            $line2=join("\t",@inff);
          $insert = $x1 - $x2 + $len1;
            $insert{$insert}++;
            $fh{$chr1}->print($line1);
            $fh{$chr2}->print($line2);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/A/A/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/T/T/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/C/C/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/G/G/g);

            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/A/A/g);
            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/T/T/g);
            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/C/C/g);
            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/G/G/g);

           $all_Depth+=($len1+$len2) ; $all_read+=2;
            $Read_chr{$chr1}++; $Depth_chr{$chr1}+=$len1 ;
            if  ($n1==1)
            { 
                $uniq_read++;
                $uniq_Depth+=$len1;
                $Read_uniq_chr{$chr1}++;
                $Depth_Uniq_chr{$chr1}+=$len1;
            }
            $Read_chr{$chr2}++; $Depth_chr{$chr2}+=$len2 ;
            if  ($n2==1)
            { 
                $uniq_read++;
                $uniq_Depth+=$len2;
                $Read_uniq_chr{$chr2}++;
                $Depth_Uniq_chr{$chr2}+=$len2;
            }
        }
        else
        {
            my @inf=split(/\t/,$line1);
            $inf[0]=$Read_id ;
            $line1=join("\t",@inf);
            my @inff=split(/\t/,$line2);
            $inf[0]=$Read_id ;
            $Read_id++;
            $line2=join("\t",@inff);
            $fh{$chr1}->print($line1);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/A/A/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/T/T/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/C/C/g);
            $MisMatch{$chr1}+= (0+$inf[-1] =~ s/G/G/g);

            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/A/A/g);
            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/T/T/g);
            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/C/C/g);
            $MisMatch{$chr2}+= (0+$inff[-1] =~ s/G/G/g);

           $fh{$chr2}->print($line2);
            $all_Depth+=($len1+$len2) ; $all_read+=2;
            $Read_chr{$chr1}++; $Depth_chr{$chr1}+=$len1 ;
            if  ($n1==1)
            { 
                $uniq_read++;
                $uniq_Depth+=$len1;
                $Read_uniq_chr{$chr1}++;
                $Depth_Uniq_chr{$chr1}+=$len1;
            }
            $Read_chr{$chr2}++; $Depth_chr{$chr2}+=$len2 ;
            if  ($n2==1)
            { 
                $uniq_read++;
                $uniq_Depth+=$len2;
                $Read_uniq_chr{$chr2}++;
                $Depth_Uniq_chr{$chr2}+=$len2;
            }
        }
    }
    close IN;
    my $missbase=0;
    foreach my $k (sort keys %fh)
    {
        my $temp=0;  my $temp2=0;
        next if  (!exists $Read_uniq_chr{$k});
        if ($Read_uniq_chr{$k}!=0)
        {
            $temp=$Depth_Uniq_chr{$k}/$Read_uniq_chr{$k};
        }
        if ($Read_chr{$k}!=0)
        {
            $temp2=$Depth_chr{$k}/$Read_chr{$k};
        }
        $missbase+=$MisMatch{$k};
    print Info "$k\t$Read_uniq_chr{$k}\t$Depth_Uniq_chr{$k}\t$temp\t$Read_chr{$k}\t$Depth_chr{$k}\t$temp2\t$MisMatch{$k}\n";
    }
    print Info "Genome\t$uniq_read\t$uniq_Depth\t",$uniq_Depth/$uniq_read,"\t$all_read\t$all_Depth\t",$all_Depth/$all_read,"\t$missbase\n";
}

foreach my $k( keys %fh)
{
    $fh{$k}->close ;
}
close Info ;


my $max_y = 0;
my $max_x = 0;
while (my ($k, $v) = each %insert) {
    if ($max_y < $v) {
        $max_y = $v;
        $max_x = $k;
    }
}
my $cutoff = $max_y / 1000;
   $cutoff = 3 if $cutoff<3;

my @insert;
my @count;
my @cumul;

foreach (sort {$a<=>$b} keys %insert) {
    if ($insert{$_} < $cutoff){
        $total_uniq_low_pair += $insert{$_};
    }
    else {
        $total_uniq_normal_pair += $insert{$_};
        push @insert, $_;
        push @count,  $insert{$_};
        push @cumul,  $total_uniq_normal_pair ;
    }
}

#my $half = $total_uniq_normal_pair/2;
#my $median;
#for (my $i=0; $i<@insert; $i++) {
#	if ($cumul[$i]>=$half) {
#		$median = $insert[$i];
#		last;
#	}
#}
my $median = $max_x;

my $Lsd=0; my  $Rsd=0 ; my  $Lc=0 ; my  $Rc=0 ;

for (my $i=0; $i<@insert; $i++) {
    my $diff = $insert[$i] - $median;
    if ($diff < 0) {
        $Lsd += $count[$i] * $diff * $diff;
        $Lc += $count[$i];
    }
    elsif ($diff > 0) {
        $Rsd += $count[$i] * $diff * $diff;
        $Rc += $count[$i];
    }
}

$Lsd = sprintf ("%d", sqrt($Lsd/$Lc) ) if ($Lc!=0);
$Rsd = sprintf ("%d", sqrt($Rsd/$Rc) ) if ($Rc!=0);

$total_uniq_pair = $total_uniq_low_pair + $total_uniq_normal_pair;
$total_single = $total_map_reads - $total_repeat_pair * 2 - $total_uniq_pair * 2;

open OUT, ">$out";
print OUT "#          Mapped reads: $total_map_reads\n";
print OUT "#          Single reads: $total_single\n";
print OUT "#           Repeat pair: $total_repeat_pair\n";
print OUT "#             Uniq pair: $total_uniq_pair\n";
print OUT "#    low frequency pair: $total_uniq_low_pair\n";
print OUT "# normal frequency pair: $total_uniq_normal_pair\n";
print OUT "#        Peak: $median\n";
print OUT "#        SD: -$Lsd/+$Rsd\n";

my $lsd = $median - 3*$Lsd;
my $rsd = $median + 3*$Rsd;

$lane =~ s/\.soap//;
my @aaa = split(/\./ ,$lane) ;
@aaa = split(/\_/,$lane) if  (!defined $aaa[4]);

print "$lane\t$aaa[-1]\t1\t$length1\t$length1\t$median\t$lsd\t$rsd\t$Lsd\t$Rsd\n";

for (my $i=0; $i<@insert; $i++) {
    print OUT "$insert[$i]\t$count[$i]\n";
}
close OUT;

############ swimming in the sky and filying in the sea #########
