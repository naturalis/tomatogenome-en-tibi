#!/usr/bin/perl-w
use Getopt::Long;
use FindBin qw($Bin);
use strict;
#explanation:this program is edited to 
#edit by HeWeiMing;   Tue May 11 14:27:32 CST 2010
#Version 1.0    hewm@genomics.org.cn 
sub  usage
{
    print STDERR <<USAGE;
         Version:1.0    2009-10-22       hewm\@genomics.org.cn

      Options
          -fqlist    <s> : input  fq.gz.list or fq.list
          -ref       <s> : ref for soap ( #.index )

          -chrList   <s> : chr name list(RefLeng.pl out)
          -library       : use library to mkdir
         
          -runIndel      : whether to run soapindel
          -qsub          : qsub the shell 
          -outDir    <s> : OutPut Dir  [pwd]
          -laneID    <n> : start lane id for sv [80] 
          -gap       <n> : indel soap of gap  [0]
          -trim      <n> : soap trim of read  [35]
          -mis       <n> : soap mismatch of read  [3]
          -mem           : the memory to qsub [3.6688G]
          -BinDir    <s> : Bin Dir [/ifs2]
          -help          : show this help
USAGE
}

my ($ref,$chrlist,$BinDir ,$fqlist ,$mem, $mis ,$qsub ,$outDir,$chr_prefix,$trim,$help,$gap,$laneID);
my ($runIndel,$library) ;

GetOptions(
    "chrlist:s"=>\$chrlist,
    "fqlist:s"=>\$fqlist,
    "ref:s"=>\$ref,
    "laneID:s"=>\$laneID,
    "mis:s"=>\$mis,
    "mem:s"=>\$mem,
    "runIndel:s"=>\$runIndel,
    "gap:s"=>\$gap,
    "library:s"=>\$library,
    "trim:s"=>\$trim,
    "qsub"=>\$qsub,
    "BinDir:s"=>\$BinDir,
    "outDir:s"=>\$outDir,  
    "chr_prefix:s"=>\$chr_prefix,
    "help"=>\$help,
);

$BinDir||=$Bin;
my $allbin=$BinDir;  $allbin=~s/\/Soap//g ;
my $osh="/home/heweiming/bin/Temple/osh.pl";
   $osh="$BinDir/osh.pl" unless (-s $osh) ;
   $osh="perl  $osh" ;
$mem||="3.6688G" ;
$trim||=35 ;
$chr_prefix||="chr";
my $OUT=`pwd`; chomp $OUT ;
$outDir||=$OUT ;
$mis||=3;  $laneID||=79;
if (defined ($gap))
{
 $mis=$mis." -g $gap";
}
#############Befor  Start  , open the files ####################
if(!defined($fqlist) || !defined($ref) || defined($help))
{
    usage;
    exit ;
}

my $index=(split(/\./,$ref))[-1];
if  ($index ne "index" )
{
    print "may the ref wrong\nthe suffix must be\tindex\n";
    exit (1);
}

    my $RefFA=$ref ;
       $RefFA =~s/\.index//g ;
if (defined($runIndel))
{
    if (-s $RefFA )
    {
    }
    else
    {
     print "To run SaopIndel:\n$RefFA\tmust exists\n";
     exit (1);
    }
    if (!defined ($gap))
    {
     $mis=$mis." -g 10";
     print "U did't add -gap ,But to run soapindel we add -gap 10\n" ;
    }
}
else
{
    if(!defined($chrlist))
    {
        $chrlist=$ref ;
        $chrlist =~s/index/chrlist/g ;
        if (-s $chrlist )
        {
        }
        else
        {
          print "\t-chrList\t$chrlist\twrong\n";
          print "u can use the follow bin to new it\n";
          my $RefLeng="perl  $allbin/Ref/RefLeng.pl ";
          print "$RefLeng $RefFA\n";
          exit (1);
        }
    }

    open (ListChr,"<$chrlist") or die "$!";
    my $TF_chr_pr=0;
    my $chr_prefix_temp=$chr_prefix ;
    
    while(<ListChr>)
     {
         chomp ; 
         my @inf=split ;
         if ($#inf!=4)
         {          
            print "may the  $chrlist format wrong\n";
            print "u can use the follow bin to new it\n";
            my $RefLeng="perl  $allbin/Ref/RefLeng.pl ";
            print "$RefLeng $RefFA\n";
            exit(1);
         }         
         $inf[0] =~s/([0-9].+)//g;
         $inf[0] =~s/([0-9].*)//g;
         next if  ($inf[0] eq "" );
         if  ($chr_prefix eq $inf[0] )
         {
             $TF_chr_pr=1;
             last ;
         }
         else
         {
             $chr_prefix=$inf[0];
         }
     }
     close ListChr ;
     $chr_prefix=$chr_prefix_temp if ($TF_chr_pr!=1);
}

my $soap="$BinDir/soap2.21.xd" ;
my $instep1="perl  $BinDir/Soap2InsertChr.pl";
my $instep2="perl  $BinDir/soap2_insert_step2.pl";
my $sortDedup="perl  $BinDir/chrSort2SortDedup.pl" ;
my $soapIndel="$BinDir/soapInDelV1.08";
my $soapSV="$BinDir/soapsv";

################ Do what you want to do #######################
##################################################################################
open (A ,"<$fqlist")  || die "$!" ;
open (LAID ,">>$OUT/IandID")  || die "$!" ;

while(<A>)
{
    chomp ;
    my $file=$_  ;
    my @inf=split (/\// , $file ) ;
    my @temp=split (/\./ , $inf[-1]) ;
    my $outfile=join("\.",@temp[0..$#temp-1]);
    my @Wen=split (/\_/ , $temp[0]) ;

    my $Dir_lane=$inf[-2] ;    
       $Dir_lane=$Wen[-2] if (defined $library);
       $laneID++;
       print LAID $inf[-2],"\t$Wen[-2]\t$laneID\n"; 
    my $OUTDir=$OUT;

    system ("mkdir -p $OUTDir");
    chdir  $OUTDir ;
    my $OODir= $OUTDir."\/$Dir_lane";
    system ("mkdir -p  $OODir");
    my $outFile1= $OODir."\/$outfile" ;
    chdir   $OODir   ;

    @temp=();  @temp=split (/\_/,$outfile);
    $outfile=();
    my $outfile_pre=join("\_",@temp[0..$#temp-1]);
    my $outfile=$outfile_pre."\.single";
    my $PE_OUT= $OODir."\/$outfile" ;

    my $inser_info=$OODir."\/inser.info" ;
    my $chrDir=$OODir."\/chr";
    my $sort_out=$OODir."\/SoapBychrSort";
    my $chrInfo=$chrDir."Uniq.info";
    system ("mkdir -p  $chrDir ");
    system ("mkdir -p  $sort_out ");
    if  ( !defined ($runIndel))
    {
    system  (" $osh 01 01 S$Dir_lane   $soap  -a   $file  -D  $ref  -s  $trim   -l 32   -v   $mis   -p    4   -o  $PE_OUT  ^ $instep1  $chrlist $chrInfo  $chrDir  $PE_OUT  \\\>\\\> insert.sd.info  ^ rm  $PE_OUT  ^ $sortDedup  -inDir   $chrDir   -outDir  $sort_out  -rmsoapBychr  -chr_prefix  $chr_prefix  -laneID  $laneID -chrlist $chrlist  ") ;
   }
   elsif (defined ($runIndel) )
   {
    system ("rm -rf  $chrDir  $sort_out  ");
    system  (" $osh 01 01 S$Dir_lane   $soap  -a   $file  -D  $ref  -s  $trim   -l 32   -v   $mis   -p   4  -o  $PE_OUT  ^  ls $PE_OUT  \\\> $OODir/soap.list    ^ $soapIndel -s  $OODir/soap.list  -f $RefFA -o $OODir/indel-result.list  ");
   }
 system ("qsub  -cwd -l vf=$mem -S  /bin/sh S$Dir_lane.sh ") if ( defined $qsub);
}
close LAID ;
close A ;
######################swimming in the sky and flying in the sea #########################