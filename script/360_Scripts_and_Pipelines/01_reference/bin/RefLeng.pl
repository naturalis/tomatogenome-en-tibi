#!/usr/bin/perl-w
use strict;
#explanation:this program is edited to 
#edit by HeWeiMing;
die "Version 1.0 2009-5-20;\nUsage: $0 <InPut.fa>[out(InPut.fa.chrlist)]\n" unless (@ARGV == 1 || @ARGV == 2 );

open (A,"<$ARGV[0]")  || die "$!" ;
if (!defined ($ARGV[1]))
{
    $ARGV[1]="$ARGV[0]\.chrlist" ;
}
open (OA,">$ARGV[1]") || die "output file can't open $!" ;
$/=">";
<A>;

while(<A>) 
{ 
    chomp ;
    my @inf=split /\n/ ;
    my $chr=(split(/\s+/,$inf[0]))[0];
    my $line=join("", @inf[1..$#inf]);
        @inf=();
    my $Sumleng=length($line);
       $line=uc($line);
    my $GC=0+($line=~s/G/G/g);
       $GC+=(0+($line=~s/C/C/g));
    my $Nleng=0+($line=~s/N/0/g);
       $Nleng||=0 ; $GC||=0 ; $Sumleng||=0;
    print OA  $chr,"\t$Sumleng\t$Nleng\t", $Sumleng-$Nleng,"\t$GC\n";
}
close A;
close OA ;
