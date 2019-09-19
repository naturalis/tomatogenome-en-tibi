#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  filter.pl
#
#  DESCRIPTION: this pl used to remove adapter and filter the Qulity from raw data
#				It will take about X hours and <0.5g resource for resequencing-data
#
#       AUTHOR:  Mingyu Yang, yangmingyu@genomics.cn
#      COMPANY:  BGI Shenzhen
#      VERSION:  1.0
#      CREATED:  10/19/2010 04:45:41 PM
#===============================================================================

use strict;
use warnings;
use PerlIO::gzip;
use Getopt::Long;

my $usage=<<USAGE;
usage: $0
    -p  <path>
    -n1 <N_rate>
    -n2 <min_quality>
    -n3 <min_quality_rate>
USAGE
my ($path,$adapter_list_1,$adapter_list_2,$gz_infile_1,$gz_infile_2,$gz_outfile_1,$gz_outfile_2,$N_rate,$min_quality,$min_quality_rate,$help);
GetOptions(
    "p=s"=>\$path,
    "n1:i"=>\$N_rate,
    "n2:i"=>\$min_quality,
    "n3:i"=>\$min_quality_rate,
    "h:s" => \$help,
);

$N_rate ||= 0.1;
$min_quality ||= 69;
$min_quality_rate ||= 0.5;
die $usage if $help;
die $usage unless  $path;

print STDERR "Filter2 begin at:\t".`date`."\n";

my ($id_1,$id_2);
my %hash;
my $total_num = 0;
my $left_num = 0;
#----------------------------  deal with the first adapter  ---------------------------------#
$adapter_list_1 = `ls $path/*1.adapter.list`;
open IN,"$adapter_list_1" or die $!;
<IN>;
while(<IN>)
{
	chomp;
	my @array = split /\s+/,$_;
	my $name = (split /\//,$array[0])[0];
	$hash{$name} = 1;
}
close IN;
#----------------------------  deal with the second adapter  ---------------------------------#
$adapter_list_2 = `ls $path/*2.adapter.list`;
open IN,"$adapter_list_2" or die $!;
<IN>;
while(<IN>)
{
	chomp;
	my @array = split /\s+/,$_;
	my $name = (split /\//,$array[0])[0];
	$hash{$name} = 1;
}
close IN;
#-----------------------  rm the adapter from the fq format file ---------------------------#
#-------------------  filter the low quality from the fq format file -----------------------#
#------------------  filter the reads that N content higher than %10 -----------------------#
chomp ($gz_infile_1 = `ls $path/*1.fq.gz`);
chomp ($gz_infile_2 = `ls $path/*2.fq.gz`);
open OUT_1,">:gzip","$path/3.clean.fq.gz" or die $!;
open OUT_2,">:gzip","$path/4.clean.fq.gz" or die $!;
open IN_1,"<:gzip","$gz_infile_1" or die $!;
open IN_2,"<:gzip","$gz_infile_2" or die $!;
#i$/="@";
while(<IN_1>)
{	
	my $FQ1_1= $_ ;  chomp  ;
        $_=(split(/\//,$_))[0];
    if  (exists  $hash{$_})
    {
        <IN_1>;  <IN_1>;  <IN_1>;
        <IN_2>;  <IN_2>;  <IN_2>;  <IN_2>;
    }
    else
    {
        my $FQ1_2=<IN_1>; my $FQ1_3=<IN_1>;  my $FQ1_4= <IN_1>;
        my $FQ2_1=<IN_2>; my $FQ2_2=<IN_2>; my $FQ2_3=<IN_2>;  my $FQ2_4= <IN_2>;
        my $temp=$FQ1_2; chomp  $temp ;
        my $Read_leng=length($temp);  my $ReadN=($temp =~ s/N/N/gi)+0;
        next  if  ($ReadN/$Read_leng>0.1);
        $temp=$FQ1_4 ;  chomp  $temp ;
        my @ary=split(//,$temp);
        my $Q_cout=0;
        foreach my $k (@ary)
        {
            my $k=ord ($k) ;
            $Q_cout++  if($k<69) ;
        }
        next  if  ($Q_cout/$Read_leng>0.5);
  
         $temp=$FQ2_2; chomp  $temp ;
         $Read_leng=($temp =~ s/N/N/gi)+0;
        next  if  ($Read_leng/$Read_leng>0.1);
        $temp=$FQ2_4 ;  chomp  $temp ;
         @ary=split(//,$temp);
         $Q_cout=0;
        foreach my $k (@ary)
        {
            my $k=ord ($k) ;
            $Q_cout++  if($k<69) ;
        }
        next  if  ($Q_cout/$Read_leng>0.5);
        print  OUT_1 $FQ1_1,$FQ1_3,$FQ1_3,$FQ1_4;
        print  OUT_2 $FQ2_1,$FQ2_3,$FQ2_3,$FQ2_4;
    }
}
close OUT_1 ;
close OUT_2 ;

=aa
	if(defined $line_1 && defined $line_2)
	{
		chomp ($line_1,$line_2);
		$total_num ++;
	}
	else{last;}
	my $num_1 = 0;
	my $num_2 = 0;
	my $num_3 = 0;
	my $num_4 = 0;

	my @array_1 = split /\n/,$line_1;
	my @array_2 = split /\n/,$line_2;
	
	my $name_1 = (split /\//,$array_1[0])[0];
	my $name_2 = (split /\//,$array_2[0])[0];
	next if(exists $hash{$name_1});
	next if(exists $hash{$name_2});

	my @b_1 = split //,$array_1[3];
	my @b_2 = split //,$array_2[3];

	$num_1 += ($array_1[1] =~ s/N//gi);
	next if($num_1 >=90*$N_rate);
	$num_2 += ($array_1[2] =~ s/N//gi);
	next if($num_2 >=90*$N_rate);

	for(my $k=0;$k<@b_1;$k++)
	{
		$b_1[$k] = ord($b_1[$k]);
		if($b_1[$k]<=$min_quality)
		{
			$num_3 ++;
			redo LINE if($num_3>=90*$min_quality_rate);
		}
	}
	for(my $p=0;$p<@b_2;$p++)
	{
		$b_2[$p] = ord($b_2[$p]);
		if($b_2[$p]<=$min_quality)
		{
			$num_4 ++;
			redo LINE if($num_4>=90*$min_quality_rate);
		}
	}
	$left_num ++;
	print OUT_1 "\@$line_1";
	print OUT_2 "\@$line_2";
}
print STDERR "The total number is $total_num\n";
print STDERR "The left number is $left_num\n";
close IN;
print STDERR "Filter2 finaly at:\t".`date`."\n";
