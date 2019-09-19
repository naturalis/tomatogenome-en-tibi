#!/usr/bin/perl-w
use strict;
use Getopt::Long;
use Data::Dumper;
#explanation:this program is edited to 
#edit by HeWeiMing;   2009-09-22   hewm@genomics.org.cn
sub usage
{
    print STDERR <<USAGE;
 Version:1.0
 2009-10-22       hewm\@genomics.org.cn

         Options
            -input     <s> :  Input File  , raw  ;
            -output    <s> :  Output File ;
            -depthmin  <n> :  the filter of the lowest depth [15]
            -depthmax  <n> :  the filter of the hightest depth [2400]
            -quality   <n> :  the filter of the snp quility  [15]
            -cp        <f> :  the filter of the cp  [1.50]
            -name      <s> :  the name of the speci [Dog]
            -h             :  show this help
USAGE
}
my ($input , $depthmin , $depthmax , $quality , $output ,  $help , $cp , $name ) ;

GetOptions(
    "help"=>\$help,
    "input:s"=>\$input,
    "output:s"=>\$output,
    "depthmin:s"=>\$depthmin,
    "depthmax:s"=>\$depthmax,
    "quality:s"=>\$quality,
    "name:s"=>\$name, 
); 


if(!defined($input) || defined($help) ||  !defined($output) )
{
     usage; 
     exit ; 
}

$depthmin||=40 ;  
$depthmax||=2400 ;  $quality||=15 ; $cp||=1.50 ;
$name||="Dog";


my $num=0;
open ADDCN,"<$input"  || die "$!\n" ;
open OUT,">$output\.filter"|| die "$!\n" ;
open OUTdb,">$output\.dbsnp"|| die "$!\n" ;
#ChrU    451     G       918     0.500000        G       T       273     3       24      1.00
while(<ADDCN>) 
{ 
	chomp ; 
	my @inf=split;	
	next if($inf[3]<$depthmin || $inf[3]>$depthmax);
	next if($inf[9]<$quality);
	next if($inf[10]>$cp);  # copynumber 
	print OUT "$_\n"; 
     	my @l;
	my %hash;
	$num++;
	push @l,$inf[0],$inf[1];
		      $l[2]=1;
                      $l[3]=0;
                      $l[4]=0;
                      $hash{A}=0;
                      $hash{C}=0;
                      $hash{T}=0;
                      $hash{G}=0;
                      $hash{$inf[5]}=sprintf ("%.2f",$inf[7]/($inf[7]+$inf[8]));
                      $hash{$inf[6]}=1-$hash{$inf[5]} ;
                      my $ID = '0000000'.$num;
                      $ID=substr($ID,-8);
                      $ID=$name.$ID;
                      my $out=join "\t",@l,$hash{A},$hash{C},$hash{T},$hash{G},$ID;
                      print OUTdb $out,"\n";	
}

close  OUT;
close  OUTdb,
close  ADDCN;
