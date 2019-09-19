#!/usr/bin/perl -w
use strict;
use Data::Dumper;
use Getopt::Long;
use FindBin qw($Bin);
#edit by HeWeiMing;   2009-06-02
#Version 1.0    hewm@genomics.org.cn

my ($inDir,$outDir,$help,$chr_prefix,$msort,$rmsoapBychr,$binDir,$deplication,$laneID);
my ($chrlist);

GetOptions(
	"inDir:s"=>\$inDir,
	"outDir:s"=>\$outDir,
	"chrlist:s"=>\$chrlist,
	"laneID:s"=>\$laneID,
    "binDir:s"=>\$binDir,
    "chr_prefix:s"=>\$chr_prefix,	
    "rmsoapBychr"=>\$rmsoapBychr,
    "help"=>\$help,
    
);

sub  usage
{
     print STDERR <<USAGE;
 Version:1.0    2009-10-22       hewm\@genomics.org.cn

        Options
            -inDir      <s> : SortBychr Dir 
            -outDir     <s> : SoapBychrSortDedup  [inDir]
            -chrlist    <s> : Ref chr.length input 
            -laneID     <s> : laneID for sv [1]
            -chr_prefix <s> : chr prefix  [human18-]
            -binDir     <s> : msort deplication  bin Dir [/ifs2]
            -rmsoapBychr    : rm the soapBychr
            -help           : show this help
USAGE
}

if(!defined($inDir) || defined($help) || !defined($chrlist))
{
     usage;
     exit ;
}
 $binDir ||=$Bin ;
 $outDir ||= $inDir ;
 $laneID ||= 1 ;
 $chr_prefix ||="human18-" ;
 my $pwd=`pwd` ; 
 chomp  $pwd ;  chomp $outDir ; chomp  $inDir ;

 $msort  =  "$binDir/msort" ;
 $deplication="perl  $binDir/deplication_for_soapbysort.pl ";

chdir $inDir ; 
my $aa= `ls $chr_prefix*`;
my @chr=(split /\n/,$aa) ;
my $chr_name=$#chr ;
chdir $pwd ;

for (my $ii=0 ; $ii<=$chr_name ; $ii++)
{  
    my $infile="$inDir/$chr[$ii]" ;
    my $outfile="$outDir/$chr[$ii]\.sort";
    system (" $msort  -k n9  $infile > $outfile ");
    unlink $infile  if ( defined($rmsoapBychr));
    system ("$deplication  $outfile  $laneID  $outDir/$chr[$ii] $chrlist >> $outDir/stat.info "); 
    unlink $outfile  if  (-s $outfile) ;
}

#####################swimming in the sky and flying in the sea #################

