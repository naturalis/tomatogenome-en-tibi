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
         
          -runSV         : whether to run soapsv
          -runIndel      : whether to run soapindel
          -qsub          : qsub the shell 
          -outDir    <s> : OutPut Dir  [pwd]
          -laneID    <n> : start lane id for sv [1] 
          -min       <n> : min the insert size [100]
          -max       <n> : max the insert size [888]
          -gap       <n> : indel soap of gap  [0]
          -trim      <n> : soap trim of read  [35]
          -RefGap    <s> : soapsv gap file input [ref.fa.gap]
          -mis       <n> : soap mismatch of read  [2:45 3:70 4:90]
          -mem           : the memory to qsub [3.6688G]
          -BinDir    <s> : Bin Dir [/ifs2]
          -help          : show this help
USAGE
}

my ($ref,$chrlist,$BinDir ,$fqlist ,$mem, $qsub ,$outDir,$chr_prefix,$min,$max,$trim,$help,$gap,$laneID);
my ($runIndel,$runSV ,$library,$RefGap,$mis,$mis_match_soap ) ;
my ($min_t ,$max_t );
GetOptions(
    "chrlist:s"=>\$chrlist,
    "fqlist:s"=>\$fqlist,
    "ref:s"=>\$ref,
    "laneID:s"=>\$laneID,
    "min:s"=>\$min_t,
    "mis:s"=>\$mis_match_soap,
    "max:s"=>\$max_t,
    "mem:s"=>\$mem,
    "runSV:s"=>\$runSV,
    "runIndel:s"=>\$runIndel,
    "gap:s"=>\$gap,
    "library:s"=>\$library,
    "trim:s"=>\$trim,
    "qsub"=>\$qsub,
    "BinDir:s"=>\$BinDir,
    "outDir:s"=>\$outDir,  
    "RefGap:s"=>\$RefGap,  
    "chr_prefix:s"=>\$chr_prefix,
    "help"=>\$help,
);

$BinDir||="$Bin";
my $allbin=$BinDir;  $allbin=~s/\/Soap//g ;
my $osh="/home/heweiming/bin/Temple/osh.pl";
   $osh="$BinDir/osh.pl" unless (-e $osh) ;
   $osh="perl  $osh" ;
$mem||="3.6688G" ;
$trim||=35 ;
$chr_prefix||="chr";
my $OUT=`pwd`; chomp $OUT ;
$outDir||=$OUT ;

$min||=100;  $max||=888;
$min = $min_t if (defined ($min_t));
$max = $max_t if (defined ($max_t));

$laneID||=0;

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
if  ($index ne "index")
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


      $RefGap||=$ref ;
      $RefGap =~s/index/gap/g ;

if(defined($runSV))
{
    if (-s $RefGap)
    {
    }
    else
    {
      print "\tTo run soapsv gap file:\n$RefGap\tmust exists\n";
      print "u can use the follow bin to new it\n";
      my $RefLeng="perl  $allbin/Ref/find_Fa_N_region.pl";
      print "$RefLeng $RefFA\n";
      exit (1);
    }
}

my $soap="$BinDir/soap2.21.xd" ;
my $instep1="perl  $BinDir/Soap2InsertChr.pl";
my $instep2="perl  $BinDir/soap2_insert_step2.pl";
my $sortDedup="perl  $BinDir/chrSort2SortDedup.pl" ;
my $soapIndel="$BinDir/soapInDelV1.08";
my $soapSV="$BinDir/soapsv";
my $in_sd="perl $BinDir/read_sv_insert_input.pl";

################ Do what you want to do #######################
#############################################################################

###################### swimming in the sky and flying in the sea #########################
##                      swimming in the sky and flying in the sea                       ##
##########################################################################################

open (A ,"<$fqlist")  || die "$!" ;
open (LAID ,">>$OUT/IandID")  || die "$!" ;

while($_=<A>)
{
    chomp ;
    my @pppcc=split ;
    $min = int($pppcc[1]) if (( defined ($pppcc[1])) );
    $max = int($pppcc[2]) if (( defined ($pppcc[2])) );
    $min = $min_t if (defined ($min_t));
    $max = $max_t if (defined ($max_t));
 
    my $file=$pppcc[0]  ;
    my @inf=split (/\// , $file ) ;
    my @temp=split (/\./ , $inf[-1]);
    my $outfile=join("\.",@temp[0..$#temp-1]);
    my @Wen=split (/\_/ , $temp[0]) ;
    
    if ($file =~ /.gz$/)
    {
        open (FQ_Temp , "gzip -cd $file |") or die $!;
    }
    elsif ($file =~ /.bz2$/)
    {
        open (FQ_Temp , "bzip2 -cd $file |") or die $!;
    }
    else
    {
     open (FQ_Temp ,"<$file")  || die "$!" ;
    }
    my $bad_temp=<FQ_Temp>;  $bad_temp=<FQ_Temp>;
    chomp  $bad_temp ;
    my $Read_len=length($bad_temp);
    my $mis_match=1 ;
       if ($Read_len>90)
       {
            $mis_match=4;
       }
       elsif($Read_len>=70)
       {
           $mis_match=3 ;
       }
       elsif($Read_len>=45)
       {
            $mis_match=2 ;
       }     
    close FQ_Temp ;
        if (! defined($mis_match_soap))
        {
            $mis=$mis_match;
        }

    my $Dir_lane=$inf[-2] ;    

      $Dir_lane=$Wen[-2]  if  (defined $library );
       $laneID++;
       print LAID $inf[-2],"\t$Wen[-2]\t$laneID\t$Dir_lane\n"; 
    my $OUTDir=$OUT;

    system ("mkdir -p $OUTDir ");
    chdir  $OUTDir ;
    my $OODir= $OUTDir."\/$Dir_lane";
    system ("mkdir -p  $OODir  ");
    my $outFile1= $OODir."\/$outfile" ;
    chdir   $OODir   ;

    $_=<A>;
    chomp ;
     @pppcc=split ;
    my  $file2=$pppcc[0] ;  @inf=();
    @inf=split (/\// , $file2) ;
    @temp=();   @temp=split (/\./,$inf[-1]);
    $outfile=join("\.",@temp[0..$#temp-1]);
    my $outFile2= $OODir."\/$outfile" ;

    @temp=();  @temp=split (/\_/,$outfile);
    $outfile=();
    my $outfile_pre=join("\_",@temp[0..$#temp-1]);
    my $outfile=$outfile_pre."\.soap";
    my $PE_OUT= $OODir."\/$outfile" ;
       $outfile=$outfile_pre."\.single";
    my $SE_OUT=$OODir."\/$outfile" ;
    my $UNM=$OODir."\/$outfile_pre.unmapped";

    my $inser_info=$OODir."\/inser.info" ;
    my $chrDir=$OODir."\/chr";
    my $sort_out=$OODir."\/SoapBychrSort";
    my $chrInfo=$chrDir."Uniq.info";
    system ("mkdir -p  $chrDir ");
    system ("mkdir -p  $sort_out ");
    if  ( !defined ($runIndel) && !defined ($runSV) )
    {
    system  (" $osh 01 01 S$Dir_lane   $soap  -a   $file -b   $file2  -D  $ref  -m  $min -x $max    -s  $trim   -l 32   -v   $mis   -p    4   -o  $PE_OUT  -2  $SE_OUT -u $UNM 2\\\> $OODir/soap.log  ^ $instep1  $chrlist  $chrInfo  $chrDir   $PE_OUT  $SE_OUT  \\\>\\\> insert.sd.info ^ $instep2  $PE_OUT.insert ^ gzip  $PE_OUT   $SE_OUT ^ $sortDedup  -inDir   $chrDir   -outDir  $sort_out  -rmsoapBychr  -chr_prefix  $chr_prefix  -laneID  $laneID -chrlist $chrlist  ") ;
   }
   elsif (defined ($runIndel) && defined ($runSV))
   {
       print "runIndel  and runSV  can't run together\n";
   }
   elsif (defined ($runIndel) &&  !defined ($runSV) )
   {
      system ("rm -rf  $chrDir  $sort_out  ");
#    system  (" $osh 01 01 S$Dir_lane   $soap  -a   $file -b   $file2  -D  $ref  -m  $min -x $max    -s  $trim   -l 32   -v   $mis -g $gap  -p    4   -o  $PE_OUT  -2  $SE_OUT 2\\\> $OODir/soap.log  ^  ls $PE_OUT  $SE_OUT \\\> $OODir/soap.list    ^ $soapIndel -s  $OODir/soap.list  -f $RefFA -o $OODir/indel-result.list  ") ;
    system  (" $osh 01 01 S$Dir_lane   $soap  -a   $file -b   $file2  -D  $ref  -m  $min -x $max    -s  $trim -l 32   -v   $mis -g $gap  -p    4   -o  $PE_OUT  -2  $SE_OUT 2\\\> $OODir/soap.log");
  }
  elsif (!defined ($runIndel) &&  defined ($runSV) )
  {
    system  (" $osh 01 01 S$Dir_lane   $soap  -a   $file -b   $file2  -D  $ref  -m  $min -x $max    -s  $trim   -l 32   -v   $mis   -p    4   -o  $PE_OUT  -2  $SE_OUT -u $UNM 2\\\> $OODir/soap.log  ^ $instep1  $chrlist  $chrInfo  $chrDir  $PE_OUT  $SE_OUT   \\\>\\\> insert.sd.info ^ $instep2  $PE_OUT.insert ^ rm  $PE_OUT   $SE_OUT ^ $sortDedup  -inDir   $chrDir   -outDir  $sort_out  -rmsoapBychr  -chr_prefix  $chr_prefix  -laneID  $laneID  -chrlist $chrlist   ^    mkdir  -p  $OODir/SoapSV  ^ ls $sort_out/$chr_prefix\\\* \\\>  $OODir/SoapSV/soap.list ^ $in_sd   insert.sd.info  $laneID  $OODir/SoapSV/insert.info  ^ $soapSV  -i  $OODir/SoapSV/soap.list    -cl     3   -o  $OODir/SoapSV  -gap  $RefGap -2  -insert   $OODir/SoapSV/insert.info   " );
   }
   system ("qsub  -cwd -l vf=$mem -S  /bin/sh S$Dir_lane.sh ") if ( defined $qsub);
}

close LAID ;
close A ;
chdir $OUT  ;
=b
my $read_soap_report="perl   $BinDir/stat/read_soap_report.pl " ;
my $Read_Uniq_Read_Base="perl   $BinDir/stat/Read_Uniq_Read_Base.pl ";
my $Depth_cover="perl   $BinDir/stat/Depth_cover.pl ";
my $new_stat_table="perl   $BinDir/stat/new_stat_table.pl ";
my $Read_Insert_size="perl   $BinDir/stat/Read_Insert_size.pl ";
=cut
system  ("$osh 01 01 Stat OUT=\\\`pwd\\\`  ^  BinDir=$BinDir/stat  ^ mkdir  -p \\\$OUT/stat ^  ls \\\$OUT/\\\*/insert.sd.info \\\> \\\$OUT/stat/temp.list ^ perl \\\$BinDir/Read_Insert_size.pl  \\\$OUT/stat/temp.list  \\\>  \\\$OUT/stat/insert.stat  ^  tail  -n 10  \\\$OUT/\\\*/soap.log  \\\>   \\\$OUT/stat/soap.log  ^ perl \\\$BinDir/read_soap_report.pl  \\\$OUT/stat/soap.log  \\\> \\\$OUT/stat/mapping.stat ^  ls  \\\$OUT/\\\*/chrUniq.info  \\\>  \\\$OUT/stat/temp.list ^ perl \\\$BinDir/Read_Uniq_Read_Base.pl  \\\$OUT/stat/temp.list  \\\$OUT/stat/Uniq_Read_Base.stat ^  ls  \\\$OUT/\\\*/SoapBychrSort/stat.info \\\> \\\$OUT/stat/temp.list ^ perl \\\$BinDir/Depth_cover.pl   \\\$OUT/stat/temp.list \\\> \\\$OUT/stat/Depth_cover.stat  ^ perl \\\$BinDir/new_stat_table.pl  \\\$OUT/stat/mapping.stat   \\\$OUT/stat/Uniq_Read_Base.stat \\\$OUT/stat/Depth_cover.stat   \\\$OUT/stat/insert.stat  \\\> \\\$OUT/Final_stat.report ^ cp  \\\$OUT/Final_stat.report   \\\$OUT/stat/Final_stat.report  ^ rm \\\$OUT/stat/temp.list  ^   echo Final_stat.report had done! ");
print "\tAfter all the soap run out. sh\tStat.sh\tfor stat infomation\n" ;

###################### swimming in the sky and flying in the sea #########################
