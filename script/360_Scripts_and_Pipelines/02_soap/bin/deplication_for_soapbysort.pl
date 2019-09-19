#!/usr/bin/perl-w
use strict;
#explanation:this program is edited to 
#edit by HeWeiMing;   Thu Sep 17 18:48:50 CST 2009
#Version 1.0    hewm@genomics.org.cn 
die "Version 1.0\t2009-09-17;\nUsage: $0 <SoapBychrSort><lane2id><OUT><chr.length>\n" unless (@ARGV ==4);
#############Befor  Start  , open the files ####################

open	 (INFile,"<$ARGV[0]")  || die "input file can't open $!" ;
open     (OutFile,">$ARGV[2]\.dedup") || die "output file can't open $!" ;
open     (Info,"<$ARGV[3]") || die "output file can't open $!" ;
my $chr=( split(/\./ ,((split(/\//,$ARGV[0]))[-1])))[0] ;
my %Ref_info=();
    while(<Info>)
    {
        chomp ;
        my @inf=split ;
        $Ref_info{$inf[0]}=[$inf[1],$inf[2],$inf[3],$inf[4]];
    }
    close Info ;
    if (!exists $Ref_info{$chr})
    {
        print "may be the chr name wrong!\n" ;
    }

my %dupe=();
my %dused=();
my $TF=0;


################ Do what you want to do #######################
my $first=<INFile> ;
chomp  $first ;
my @tem=split (/\s+/, $first );

    while(<INFile>) 
	{
		chomp ; 
		my @inf=split ; 
        if($inf[8] != $tem[8])
        {
           if ($TF!=0)
           {
            if (exists $dupe{$tem[0]})
            {
              $dused{$tem[0]}=$tem[8];
            }
            else
            {
              $dupe{$tem[0]}=$tem[8];
            }
               $TF=0;
           }
           $tem[8]=$inf[8] ;
           $tem[0]=$inf[0] ;
        }
        else
        {
            if (exists $dupe{$tem[0]})
            {
                $dused{$tem[0]}=$tem[8];
            }
            else
            {
                $dupe{$tem[0]}=$tem[8];
            }
              $tem[8]=$inf[8] ;
              $tem[0]=$inf[0] ;
              $TF=1;
        }
	}
close INFile;

my %repeat=();
my %cout=();

foreach my $ke ( keys %dused)
{
     my  $key=();
     if ($dused{$ke} > $dupe{$ke})
     {
         $key=$dupe{$ke}."_".$dused{$ke};
     }
     else 
     {
         $key=$dused{$ke}."_".$dupe{$ke};
     }
     $repeat{$key}.=$ke."\t";
     $cout{$key}++; 
}

%dupe=();
%dused=();

my  %killid=();
foreach my $ke (keys %cout)
{
    if($cout{$ke} > 1)
    {
        my  @tempid=split (/\s+/,$repeat{$ke}) ;
        for(my $ii=1; $ii<=$#tempid ; $ii++)
        {
            my $kil=$tempid[$ii];
#            print $kil,"\n";
               $killid{$kil}=1;
        }
    }
}

%repeat=();  %dupe=();  %cout=(); 

open  (INFile,"<$ARGV[0]")  || die "input file can't open $!" ;
my $printline=();
my $printtime=0;
my %hashid=();
my $cout=1;
my  $id=$ARGV[1] ;

#  $Ref_info{$inf[0]}=[$inf[1],$inf[2],$inf[3],$inf[4]];
   my $chr_leng=$Ref_info{$chr}->[0];
   my $chr_Use_leng=$Ref_info{$chr}->[2];
   my $Ref_GC=$Ref_info{$chr}->[3];
   my $seq_fa= 'N' x $chr_leng ;   my $depth_sum=();
   my $seq_Uniq_fa= 'N' x $chr_leng ;  my $depth_uniq_sum=();

while ($_=<INFile>)
{
    my  @inf=split (/\s+/,$_ ) ;
    if (exists $killid{$inf[0]} )
    {
        next ; 
    }
    $_="$id-$_";
    $depth_sum+=$inf[5];
    substr($seq_fa,$inf[8]-1,$inf[5])= $inf[1];
    if ($inf[3]==1)
    {
     $depth_uniq_sum+=$inf[5];
     substr($seq_Uniq_fa,$inf[8]-1,$inf[5])= $inf[1];
    }

    if($printtime<1000)
    {
        $printline=$printline.$_;
        $printtime++;
    }
    else
    {
    print OutFile $printline;
    $printline=();
    $printline=$_;
    $printtime=1;
    }
}
print OutFile $printline;
close OutFile ;
     
    my $temp=(0+($seq_fa=~s/N/N/g));
    my $cov_leng=$chr_leng-$temp;
    my $GC_cov=(0+($seq_fa=~s/G/G/g));
       $GC_cov+=(0+($seq_fa=~s/G/G/g));
    my $covaa=sprintf("%.2f",$cov_leng*100/$chr_Use_leng);
    my $mean_depth=sprintf("%.2f",($depth_sum)/($chr_Use_leng));
    my $GC_of_cover=sprintf("%.2f",($GC_cov*100/$cov_leng));
    my $GC_of_fa=sprintf("%.2f",($Ref_GC*100/$chr_Use_leng));
    
    my $temp2=(0+($seq_Uniq_fa=~s/N/N/g));
    my $cov_leng_uniq=$chr_leng-$temp2;
    my $GC_cov_uniq=(0+($seq_Uniq_fa=~s/G/G/g));
       $GC_cov_uniq+=(0+($seq_Uniq_fa=~s/G/G/g));
    my $covaa_uniq=sprintf("%.2f",$cov_leng_uniq*100/$chr_Use_leng);
    my $mean_depth_uniq=sprintf("%.2f",($depth_uniq_sum)/($chr_Use_leng));
    my $GC_of_cover_uniq=sprintf("%.2f",($GC_cov_uniq*100/$cov_leng_uniq));

print "$chr\t$mean_depth\t$covaa\t$GC_of_cover\t$mean_depth_uniq\t$covaa_uniq\t$GC_of_cover_uniq\t$GC_of_fa\t$depth_sum\t$cov_leng\t$GC_cov\t$depth_uniq_sum\t$GC_cov_uniq\t$chr_Use_leng\t$cov_leng_uniq\t$chr_leng\t$Ref_GC\n" ;

######################swiming in the sky and flying in the sea #############################
