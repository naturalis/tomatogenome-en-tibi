#!/usr/bin/perl -w
use strict;
use Getopt::Long;
#explanation:this program is edited to 
#edit by HeWeiMing;   Thu Jan  6 17:36:10 CST 2011
#Version 1.0    hewm@genomics.org.cn 
my  ($input,$output,$ylim,$xlab,$ylab,$xlim,$help,$NoRm) ;

GetOptions(
    "input:s"=>\$input,
    "output:s"=>\$output,
    "ylim:s"=>\$ylim,
    "xlim:s"=>\$xlim,
    "ylab:s"=>\$ylab,
    "xlab:s"=>\$xlab,
    "NoRm:s"=>\$NoRm,
    "help"=>\$help,
);

sub  usage
{
print  STDERR<<USAGE
    Version:1.0    2009-10-22       hewm\@genomics.org.cn

    -input   <s> : Input file the stat out of the LD
    -output  <s> : output the pdf file
    
    Options
    -ylim   <s> : R ylim [1]
    -xlim   <s> : R xlim [End]
    -ylab   <s> : R ylab [Num(#)]
    -xlab   <s> : R xlab [Distance]
    -NoRm       : rm the temp file  [rm]

USAGE
}
$xlab||="Distance" ;
$ylab||="Num(#)" ;
$ylim||=1 ;
$xlim="r[,5],xlim=c(0,$xlim)" if(defined($xlim));
$xlim||="r[,5]";

if(!defined($input) || !defined($output)) 
    {
        usage();
        exit(1);
    }


#############Befor  Start  , open the files ####################

#open (IA,"$ARGV[0]") || die "input file can't open $!";
    my $tempfile="$output.R";
    open(OA,">$tempfile") || die "output file can't open $!";
################ Do what you want to do #######################

sub  Print{
print  OA<<USAGE
pdf("$output");
read.table("$input")->r;
plot(r[,1],$xlim,type="l",col="blue",bty="n",xlab="$xlab",ylab="$ylab",ylim=c(0,$ylim));
lines(r[,1],r[,6],col="red",);
legend("topright",c("R^2","D'"),col=c("blue","red"),lty=c(1,1),bty="n",cex=1);
dev.off();
quit();
USAGE
}
Print();    
close  OA ;

my $R_bin="/opt/blc/genome/bin/R" ;
   $R_bin="/usr/local/bin/R" unless (-e $R_bin );
system ("$R_bin  CMD BATCH $tempfile ");
unlink $tempfile if (!defined ($NoRm)) ;
$tempfile ="$tempfile"."out";
unlink $tempfile  if (!defined ($NoRm)) ;
$tempfile=".RData" ;
unlink $tempfile ;
######################swimming in the sky and flying in the sea ###########################
