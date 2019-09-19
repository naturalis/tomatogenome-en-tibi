#!/usr/bin/perl
use File::Basename;

my $popu=shift;
my $fst_dir=shift;
mkdir $popu unless (-d $popu);

for my $file(<$fst_dir/$popu/*.fst.single>){
    open IN,$file or die  "$!";
    <IN>;
    my $file_name=basename $file;
    my $out="$popu/$file_name";
    open OUT,">$out" or die  "$!";
    while(<IN>){
        chomp;
        my @f=split;
        next if($f[7] eq 'NA');
        $f[0]=~s/\"//g;
        my @e=split(/\./,$f[0]);
        print OUT "$e[0]\t$e[1]\t$f[7]\n";
    }
    close OUT;
    close IN;
}
