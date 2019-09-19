#!/usr/bin/perl
use Data::Dumper;
my $file=shift;

open IN,$file or die  "$!";
my $head=<IN>;
chomp $head;
my @head=split(/\t/,$head);
#print  Dumper \@head;
my %total;
my %fst;
while(<IN>){
    chomp;
    my @f=split;
    for(my $i=1;$i<=$#f;$i++){
        $total{$head[$i]}+=$f[$i];
        $fst{$f[0]}{$head[$i]}=$f[$i];
    }
}
close IN;
#print Dumper \%total;

print "Position\tFst\tInter_total\tInter_single\ttotal\tsingle\tX-squared\tdf\tp-value\n";
foreach my $fst(sort keys %fst){
    my $total_Intergenic=$total{Intergenic};
    my $single_Intergenic=$fst{$fst}{Intergenic};
    for(my $i=2;$i<=$#head;$i++){
        my $to=$total{$head[$i]};
        my $si=$fst{$fst}{$head[$i]};
        my $R="work.R";
        open R,">$R" or die  "$!";
        print R "c($total_Intergenic,$single_Intergenic,$to,$si)->x\n";
        print R "c(2,2)->dim(x)\n";
#        print R "chisq.test(x)\n";
        print R "chisq.test(x,correct=F)\n";
#        print R "fisher.test(x)\n";
        print R "q()\n";
        close R;
        my $r_out=`/opt/blc/genome/biosoft/R/bin/R < work.R --vanilla`;
        my @r_out=split(/\n/,$r_out);
        for my $aa( @r_out){
            if($aa=~/X-squared/){
                $aa=~s/\s+//g;
                my @aa=split(/\=/,$aa);
#                X-squared = 10.2266, df = 1, p-value = 0.001384
#                X-squared = 4.4141, df = 1, p-value = 0.03564
#                X-squared=0.3017,df=1,p-value=0.5828
                $aa[1]=~s/,df//;
                $aa[2]=~s/,p-value//;
                print  "$head[$i]\t$fst\t$total_Intergenic\t$single_Intergenic\t$to\t$si\t$aa[1]\t$aa[2]\t$aa[3]\n";
            }
        }
    }
}

