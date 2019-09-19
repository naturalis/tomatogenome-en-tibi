#!/usr/bin/perl -w
use strict;
use Data::Dumper;
use Getopt::Long;
use File::Basename;
use FindBin qw($Bin);
#edit by HeWeiMing;   2009-06-02
#Version 1.0    hewm@genomics.org.cn
my ($outDir,$help,$BinDir,$input,$qsub,$maxdis,$mem,$maf,$hwcutoff);

GetOptions(
    "input:s"=>\$input,
    "mem:s"=>\$mem,
    "maxdis:s"=>\$maxdis,
	"outDir:s"=>\$outDir,
    "BinDir:s"=>\$BinDir,
	"help"=>\$help,
	"qsub"=>\$qsub,
	"maf:s"=>\$maf,
        "hwcutoff:s"=>\$hwcutoff,
);

sub  usage
{
     print STDERR <<USAGE;
 Version:1.0    2010-03-22       hewm\@genomics.org.cn

            -input  <s> : Input file (genotype.list)
        
        Options
            -outDir <s> : output dir [pwd]
            -maxdis <s> : maxdistance (units:k) [250]
            -BinDir <s> : Bin Dir [/ifs2/..]
            -qsub   <s> : qsub the job shell to the BLC
            -mem   <s>  : the memory to qsub the job [1.68G]
            -maf   <s>  : minor alle frequency [0.10]
            -hwcutoff <s>: Hardy-Weinberg equilibrium p value [0.001]
            -help       : show this help
USAGE
}

if(!defined($input) || defined($help) )
{
     usage;
     exit ;
}
$maxdis||=250;   my $Long_dis=$maxdis*1000 ;    
$mem||="20G" ;
$maf ||=0.10;
$hwcutoff ||=0.001;
$BinDir||=$Bin;
my $osh="perl  $BinDir/osh.pl" ;
my $genotype2pedigree="perl  $BinDir/genotype2pedigree.pl" ;
my $Haploview="java    -jar   $BinDir/Haploview.4.2.jar " ;
my $LD_decay_RR_D_step1="perl  $BinDir/LD_decay_RR_D_step1.pl";
my $LD_decay_RR_D_step2="perl  $BinDir/LD_decay_RR_D_step2.pl";
my $Rplot2Decay="perl $BinDir/Rplot2Decay.pl " ;
my $fliter="perl $BinDir/filter_stat.pl  " ;

my $temp=`pwd` ; chomp $temp ;
$outDir||=$temp;
my $outDir_name=basename $outDir;
$outDir_name=substr($outDir_name,0,2);
my $shell="$outDir/shell";
my $LDOUT="$outDir/LDOUT";
my $stat="$outDir/stat";
my $plot="$outDir/plot";
my $info_filter="$outDir/info_filter";


system (" mkdir  -p $shell $LDOUT   $stat  $plot $info_filter  " );

open (List , "$input") or die "$!";
chdir $shell ;

while($_=<List>)
{
	 chomp ; 
	 my @inf=split(/\// ,$_);
	 my @ID=split(/\./,$inf[-1]);
	 my $chr=$ID[0];
	 system ("$osh  1 1  L$outDir_name\_$chr  $genotype2pedigree  $_  $LDOUT/$ID[0].ped   $LDOUT/$ID[0].info  ^ $Haploview -n   -pedfile    $LDOUT/$ID[0].ped  -info     $LDOUT/$ID[0].info  -log   $LDOUT/$ID[0].log     -maxdistance   $maxdis      -minMAF $maf     -hwcutoff       $hwcutoff      -dprime   -memory  10480   ^ $fliter     $LDOUT/$ID[0].ped.LD   \\\>   $info_filter/$ID[0].info  ^ gzip  $LDOUT/$ID[0].ped.LD  ");
# ^  $LD_decay_RR_D_step1   $LDOUT/$ID[0].ped.LD $LDOUT/$ID[0].info    1   $stat/$ID[0].match   $stat/$ID[0].unmatch   $Long_dis   ^ ls   $stat/$ID[0].match     $stat/$ID[0].unmatch   \\\> $stat/$ID[0].list   ^  $LD_decay_RR_D_step2  $stat/$ID[0].list   $plot/$ID[0].info ^  $Rplot2Decay  -input  $plot/$ID[0].info -output   $plot/$ID[0].pdf ^ gzip  $LDOUT/$ID[0].ped.LD  ");
#	 system("qsub  -P st_breeding -q st.q -cwd -l vf=$mem -S  /bin/sh L$outDir_name\_$chr\.sh ") if (defined ($qsub)) ;

}
close List ;
system("$osh  1 1  Sum   ls   $stat/\\\*match  \\\> $stat/Sum.list  ^  $LD_decay_RR_D_step2     $stat/Sum.list    $outDir/Sum.info  ^   $Rplot2Decay   -input     $outDir/Sum.info      -output     $outDir/Sum.pdf   ") ;



    ########### swimming in the sky and flying in the sea ##############
