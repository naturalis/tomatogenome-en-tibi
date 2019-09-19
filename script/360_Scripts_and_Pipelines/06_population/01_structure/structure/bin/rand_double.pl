#!/usr/bin/perl-w
use strict;
#explanation:this program is edited to 
#edit by HeWeiMing;   Thu Nov 19 09:50:28 CST 2009
#Version 1.0    hewm@genomics.org.cn 
die  "Version 1.0\t2009-11-19;\nUsage: $0 <InPut_1>\n" unless (@ARGV == 1 );
#############Befor  Start  , open the files ####################
open IA,"$ARGV[0]"  || die "input file can't open $!" ;
#open OA,">$ARGV[2]" || die "output file can't open $!" ;
################ Do what you want to do #######################

	while(<IA>) 
	{ 
#		chomp ; 
#		my @inf=split ;
        print $_ ;
        <IA> ;   <IA> ;  <IA> ;  <IA> ; 
        #   <IA> ;  <IA> ;  <IA> ; 
        #   <IA> ;  <IA> ;  <IA> ;
my $k=int (rand(2))  ;
my $kk=int (rand(2)); 
my $kkk=int (rand(2)); 
my $kkkk=int (rand(2)); 
my $kkkkk=int (rand(2)); 
my $kkkkkk=int (rand(2)); 
my $kkkkkkk=int (rand(2)); 
#if ($k==1 )
#if ($k==1 && $kk==1 )
#if ($k==1 && $kk==1 && $kkk==1 ) 
if ($k==1 && $kk==1 && $kkk==1 && $kkkk==1)
#if ($k==1 && $kk==1 && $kkk==1 && $kkkk==1 &&  $kkkkk==1)
#if ($k==1 && $kk==1 && $kkk==1 && $kkkk==1  &&  $kkkkk==1  &&  $kkkkkk==1)
#if ($k==1 && $kk==1 && $kkk==1 && $kkkk==1  &&  $kkkkk==1  &&  $kkkkkk==1  &&  $kkkkkkk==1 )
{
    print $_ ;
}

}


close IA;
#close OA ;
####################swiming in the sky and flying in the sea #############################
