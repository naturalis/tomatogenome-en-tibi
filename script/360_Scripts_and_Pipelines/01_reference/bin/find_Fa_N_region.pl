#!/usr/bin/perl-w
use strict;
#explanation:this program is edited to 
#edit by HeWeiMing;   Sat Oct  9 16:26:09 CST 2010
#Version 1.0    hewm@genomics.org.cn 

die  "Version 1.0\t2010-10-9;\nUsage: $0 <InPut.fa>[out(InPut.fa.gap)]\n" unless (@ARGV ==1 || @ARGV ==2);
#############Befor  Start  , open the files ####################
open (IA,"$ARGV[0]")  || die "input file can't open $!" ;
if (!defined ($ARGV[1]))
{
    $ARGV[1]="$ARGV[0]\.gap" ;
}
open (OA,">$ARGV[1]") || die "output file can't open $!" ;
################ Do what you want to do #######################

$/=">";
<IA> ;

#       my $N_head_position_position=index($chr_sub_seq,"N");                               
while(<IA>)
{ 
    chomp ; 
    my @inf=split /\n/ ;
    my $chr=shift @inf ;
    $chr=(split(/\s+/,$chr))[0];
    $_=join("",@inf);
    @inf=();
    $_=uc($_);
    my $N_tail_position=0 ;
    my $N_head_position=index($_,"N");    
    while($N_head_position>-1)
    {
        my $N_tail_position=index($_,"A",$N_head_position+1);
        my $temp=index($_,"C",$N_head_position+1);
        $N_tail_position=$temp if  ($temp < $N_tail_position &&  $temp > 0);
        $temp=index($_,"T",$N_head_position+1);
        $N_tail_position=$temp if  ($temp < $N_tail_position &&  $temp > 0);
        $temp=index($_,"G",$N_head_position+1);
        $N_tail_position=$temp if  ($temp < $N_tail_position &&  $temp > 0);
         if ($N_tail_position!=-1)
        {
           print OA  "$chr\t",$N_head_position+1,"\t$N_tail_position\n";
        }
        else
        {
           print OA  "$chr\t",$N_head_position+1,"\t",$N_head_position+1,"\n";
           last ;
        }
        $N_head_position=index($_,"N",$N_tail_position);
    }
}
close IA ;
$/="\n" ;
close OA ;

######################swimming in the sky and flying in the sea ###########################
