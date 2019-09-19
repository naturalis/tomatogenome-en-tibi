#!/usr/bin/perl-w
use strict;
use Getopt::Long;
#explanation:this program is edited to 
#edit by Lvjun;   Thu Aug 27 12:03:52 CST 2009
#Version 1.0    
my ($help,$Ref,$soaplist,$output,$OnlyUniq);
GetOptions(
    "Ref:s"=>\$Ref,
    "soaplist:s"=>\$soaplist,
    "output:s"=>\$output,
    "OnlyUniq"=>\$OnlyUniq,
    "help"=>\$help,
);

sub  usage
{
    print STDERR <<USAGE;
  Version:1.0    2009-08-27       hewm\@genomics.org.cn
           Options
           -Ref        <s> : input Ref.fa file 
           -soaplist   <s> : soapout.list
           -output     <s> : output file
           -OnlyUniq       : only use the uniq Read to stat
           -help           : show this help
USAGE
}

if(!defined($Ref)||defined($help)||!defined($output)||!defined($soaplist))
{
    usage();
    exit (1);
}

#die  "Version 1.0\t2009-08-27;\nUsage: $0 <InPut_1_reference_fasta.file><soaplist><>\n" unless (@ARGV ==2);
#############Befor  Start  ,open the files #########################

open	(FA,"<$Ref")  || die "$!" ;
open    (Soap,"<$soaplist") || die "$!" ;
open    (OUT,">$output")  || die "$!" ;
my %chr;

############ Do what you want to do #####################

$/=">";
<FA>;

    while(<FA>) 
    { 
        chomp ; 
        my @inf=split /\n/,$_;
        my $seq=join("",@inf[1..$#inf]);

        my $len=length($seq);
        my $id=(split(/\s+/,$inf[0]))[0];
           $seq=uc($seq) ; 
        my $GC_len =(0+( $seq =~ s/C/C/g));
           $GC_len+=(0+( $seq =~ s/G/G/g));
        my $temp=(0+( $seq=~ s/N/N/g ));
        my $use_len_chr=$len-$temp;
        $seq='N' x $len ;
        $chr{$id} = [$seq,$len,$GC_len,$use_len_chr,0];
    }
    $/="\n";
close FA ;

    while(<Soap>)
    {
        chomp;
        my $file=$_ ;
        open (AACCD ,"$file") or die "$!" ;
        while(<AACCD>)
        {
        chomp;
        my @record = split /\s+/,$_ ;
        next if  ($record[3]!=1 && defined($OnlyUniq));
        ($chr{$record[7]}->[4])+=$record[5];
        substr($chr{$record[7]}->[0],$record[8]-1,$record[5])= $record[1];
        }
        close AACCD ;
    }
close Soap;

        my ($GC_fa_Sum,$GC_cover_sum,$Depth_Sum);
        my ($cov_leng_sum,$fa_uselen_Sum,$fa_len_Sum);

    my @arry=sort keys %chr ;
    foreach my $k (@arry)
    {
        my $fa_seq=($chr{$k}->[0]);
        my $fa_len=($chr{$k}->[1]);
        my $fa_GC=($chr{$k}->[2]);
        my $fa_uselen=($chr{$k}->[3]);
        my $fa_depth=($chr{$k}->[4]);
           $chr{$k}=();
        my $fa_GC_bi=sprintf("%.2f",$fa_GC*100/$fa_uselen);

        my $temp=(0+($fa_seq=~s/N/N/g));
        my $cov_leng=$fa_len-$temp;
        my $covaa=sprintf("%.2f",$cov_leng*100/$fa_uselen);
        my $mean_depth=sprintf("%.2f",($fa_depth)/($fa_uselen));
        
        my $GC+=(0+( $fa_seq =~ s/C/C/g));
           $GC+=(0+( $fa_seq =~ s/G/G/g));
        my $GC_of_cover=sprintf("%.2f",($GC*100/$cov_leng));

print OUT "$k\t$mean_depth\t$covaa\t$fa_GC_bi\t$GC_of_cover\t$cov_leng\t$fa_depth\t$fa_uselen\t$fa_len\t$fa_GC\t$GC\n";
        
        $GC_fa_Sum+=$fa_GC;  $GC_cover_sum+=$GC;
        $Depth_Sum+=$fa_depth; $cov_leng_sum+=$cov_leng ;
        $fa_uselen_Sum+=$fa_uselen ; $fa_len_Sum+=$fa_len;

    }
                            %chr=();  
    my $mean_depth=sprintf("%.2f",$Depth_Sum/$fa_uselen_Sum);
    my $covaa=sprintf("%.2f",$cov_leng_sum*100/$fa_uselen_Sum);
    my $GC_of_cover=sprintf("%.2f",($GC_cover_sum*100/$cov_leng_sum));
    my $fa_GC_bi=sprintf("%.2f",$GC_fa_Sum*100/$fa_uselen_Sum);

print OUT "Genome\t$mean_depth\t$covaa\t$fa_GC_bi\t$GC_of_cover\t$cov_leng_sum\t$Depth_Sum\t$fa_uselen_Sum\t$fa_len_Sum\t$GC_fa_Sum\t$GC_cover_sum\n";

close OUT ;
######################swimming in the sky and flying in teh sea ###########################
