#!/usr/bin/perl
my $fst=shift;
my $position=shift;
my $chr=shift;
open IN,$fst or die  "$!";
my %fst;
while(<IN>){
    chomp;
    my @f=split;
    $fst{$f[1]}=$f[2];
}
close IN;


open PO,$position or die  "$!";
my %position;
while(<PO>){
    chomp;
    my @f=split;
    next if($f[0] ne $chr);
    if(defined $fst{$f[1]}){
        $position{$f[2]}{$f[1]}=$fst{$f[1]};    
    }
}
close PO;

foreach my $key (keys %position){
    mkdir  $key unless (-d $key);
    my $out="$key/$chr.fst";
    open OUT,">$out" or die  "$!";
    foreach my $loci(sort {$a<=>$b} keys %{$position{$key}}){
        print  OUT "$loci\t$position{$key}{$loci}\n";
    }
    close OUT;
}

