#!/usr/bin/perl-w
use strict;
#explanation:this program is edited to 
#edit by HeWeiMing;   Thu Oct 22 14:58:42 CST 2009
#Version 1.0    hewm@genomics.org.cn 

die "Version 1.0\t2009-10-22;\nUsage: $0<matchList><OutDir>\n" unless (@ARGV==2);

#############Befor  Start  , open the files ####################

open IA,"$ARGV[0]"  || die "input file can't open $!" ;

open OA,">$ARGV[1]" || die "output file can't open $!" ;

################ Do what you want to do #######################

my %hash_cout=();
my %hash_RR_sum=();
my %hash_D_sum=();
my $cout=0 ;
	while(<IA>) 
	{ 
    	chomp ; 
       my $a=$_;
       open AA ,"$a" || die $! ;
       
      while (<AA>)
      {
          chomp  ;
          my @inf=split ;
          $hash_cout{$inf[0]}+=$inf[1] ;
          $hash_RR_sum{$inf[0]}+=$inf[2];
          $hash_D_sum{$inf[0]}+=$inf[3];
	  }
      close AA ;
      $cout++;
	}
close IA;


foreach my $k (sort {$a<=>$b} keys %hash_cout)
{
    my $mean_R=$hash_RR_sum{$k}/$hash_cout{$k};
    my $mean_D=$hash_D_sum{$k}/$hash_cout{$k};
print OA $k ,"\t$hash_cout{$k}\t$hash_RR_sum{$k}\t$hash_D_sum{$k}\t$mean_R\t$mean_D\n";
}
close OA ;

######################swiming in the sky and flying in the sea #############################
