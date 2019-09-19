#!/usr/bin/perl
open IN,$ARGV[0] or die  "$!";
my $count;
my $mean;
while(<IN>){
    chomp;
    my @f=split;
    if($f[2]>0){
        $count++;
        $mean+=$f[2];
    }
}
close IN;
print  "$mean\t$count\t";
$mean=$mean/$count;
print "$mean\n";
