#!/usr/bin/perl -w
use strict;
use Data::Dumper;
use Getopt::Long;
use FindBin qw($Bin);
#edit by HeWeiMing;   2009-06-02
#Version 1.0    hewm@genomics.org.cn
my ($outDir,$help,$BinDir,$input,$qsub,$maxdis,$mem);

GetOptions(
    "input:s"=>\$input,
    "mem:s"=>\$mem,
    "maxdis:s"=>\$maxdis,
	"outDir:s"=>\$outDir,
    "BinDir:s"=>\$BinDir,
	"help"=>\$help,
	"qsub"=>\$qsub,
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
            -help       : show this help
USAGE
}

if(!defined($input) || defined($help) )
{
     usage;
     exit ;
}
$maxdis||=250;   my $Long_dis=$maxdis*1000 ;    
$mem||="1.68G" ;
$BinDir||=$Bin;
my $osh="perl  $BinDir/osh.pl" ;
my $genotype2pedigree="perl  $BinDir/genotype2pedigree.pl" ;
my $Haploview="java    -jar   $BinDir/Haploview.4.2.jar " ;
my $LD_decay_RR_D_step1="perl  $BinDir/LD_decay_RR_D_step1.pl";
my $LD_decay_RR_D_step2="perl  $BinDir/LD_decay_RR_D_step2.pl";
my $Rplot2Decay="perl $BinDir/Rplot2Decay.pl " ;

my $temp=`pwd` ; chomp $temp ;
$outDir||=$temp;
my $shell="$outDir/shell";
my $LDOUT="$outDir/LDOUT";
my $stat="$outDir/stat";
my $plot="$outDir/plot";

system (" mkdir  -p $shell $LDOUT   $stat  $plot  " );

    open (List , "$input") or die "$!";
    chdir $shell ;

    while($_=<List>)
    {
         chomp ; 
         my @inf=split(/\// ,$_);
         my @ID=split(/\./,$inf[-1]);
         my $chr=$ID[0];
     system ("$osh  1 1  L$chr  $genotype2pedigree  $_  $LDOUT/$ID[0].ped   $LDOUT/$ID[0].info  ^ $Haploview -n   -pedfile    $LDOUT/$ID[0].ped  -info     $LDOUT/$ID[0].info  -log   $LDOUT/$ID[0].log     -maxdistance   $maxdis      -minMAF 0.1     -hwcutoff       0.001      -dprime   -memory  2096   ^ $LD_decay_RR_D_step1   $LDOUT/$ID[0].ped.LD $LDOUT/$ID[0].info    1   $stat/$ID[0].match   $stat/$ID[0].unmatch   $Long_dis   ^ ls   $stat/$ID[0].match     $stat/$ID[0].unmatch   \\\> $stat/$ID[0].list   ^  $LD_decay_RR_D_step2  $stat/$ID[0].list   $plot/$ID[0].info ^  $Rplot2Decay  -input  $plot/$ID[0].info -output   $plot/$ID[0].pdf ^ gzip  $LDOUT/$ID[0].ped.LD  ");
     system("qsub  -cwd -l vf=$mem -S  /bin/sh L$chr\.sh ") if (defined ($qsub)) ;
    
    }
    close List ;
    system("$osh  1 1  Sum   ls   $stat/\\\*match  \\\> $stat/Sum.list  ^  $LD_decay_RR_D_step2     $stat/Sum.list    $outDir/Sum.info  ^   $Rplot2Decay   -input     $outDir/Sum.info      -output     $outDir/Sum.pdf   ") ;


    
    ########### swimming in the sky and flying in the sea ##############
