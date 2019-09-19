#!/usr/bin/perl -w
use strict;
use Data::Dumper;
use Getopt::Long;
#edit by HeWeiMing;   2009-06-02
#Version 1.0    hewm@genomics.org.cn
my ($list,$outDir,$help,$chromosome,$input);

GetOptions(
	"list:s"=>\$list,
    "input:s"=>\$input,
	"output:s"=>\$outDir,
    "chromosome:s"=>\$chromosome,
	"help"=>\$help,
);

sub  usage
{
     print STDERR <<USAGE;
 Version:1.0    2009-10-22       hewm\@genomics.org.cn

        Options
            -input  <s> : Input file the  multi snp( RAW ) 
            -list   <s> : Soaplist 
            -output <s> : OutPut file , addcn file
            -chr    <s> : chromosome  
            -help       : show this help
USAGE
}

if(!defined($input) || !defined($list) ||  !defined($outDir) || !defined($chromosome)  || defined($help)  )
{
     usage;
     exit ;
}

print "     SoapList       :\t$list\n";
print "InPut file(RAW snp) :\t$input\n";
print "OutPut file (Addcn) :\t$outDir\.add_cn\n"; 
print "    Chromosome      :\t$chromosome\n"; 
my $time=`date` ;
print "   Start read soap  :\t$time";

open (LIST,"<$list" ) || die "$!" ;
open (RAW ,"<$input") ||  die "$!" ;
open (OUT,">$outDir\.add_cn")||die"$!";  # print add_cn out
  
my @depth=();
my @hit=();

while(my $line=<LIST>)
{
	chomp $line;

	open IN,$line or die $!;
	while (<IN>){
		chomp;
		my ($hit,$read_len,$chr,$pos)=(split /\s+/)[3,5,7,8];
		next unless $chr eq  $chromosome;
		my $start = $pos;
		my $end = $pos + $read_len - 1;
		foreach my $j ($start..$end)
        {
			$hit[$j] += $hit;
			$depth[$j] ++;
		}
	}
	close IN;
}
close LIST;

$time=`date` ;
print " Read soap had done :\t$time";
print " Start write Addcn  \n";
$_="";

while($_=<RAW>)
 {
     chomp;
     my $inf=$_;    
     my @line=split(/\s+/,$inf);
     my $copynum="25.00";
     if(exists $depth[$line[1]] )
     {
         $copynum= sprintf ("%.2f",$hit[$line[1]] / $depth[$line[1]]);
     }
     print OUT  $inf,"\t",$copynum,"\n";
     $depth[$line[1]]=();    $hit[$line[1]]=();
 }
close OUT;
close RAW ;
$time=`date` ;
print "   Everthing Done   :\t$time";
