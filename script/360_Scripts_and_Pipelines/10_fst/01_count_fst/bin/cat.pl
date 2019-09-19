#!/usr/bin/perl
my ($exon,$inter,$intron,$nonsyn,$syn,$utr3,$utr5)=@ARGV;
my %fst;
my %count;

my $max=0;
my $min=1;

#read_file($all,'All');
read_file($exon,'Exon');
read_file($inter,'Intergenic');
read_file($intron,'Intron');
read_file($nonsyn,'Nonsynonymy');
read_file($syn,'Synonymy');
read_file($utr3,'3_UTR');
read_file($utr5,'5_UTR');
my @type=('Intergenic','Exon','Intron','3_UTR','5_UTR','Nonsynonymy','Synonymy');
my $pwd=`pwd`;
chomp $pwd;
my $out=(split(/\//,$pwd))[-1];
my $out1="cucumber_$out.fst.count";
my $out2="cucumber_$out.fst.xls";
open OA,">$out1" or die "$!";
open OB,">$out2" or die "$!";
print OA "Fst\tIntergenic\tExon\tIntron\t3_UTR\t5_UTR\tNonsynonymy\tSynonymy\n";
print OB "Fst\tIntergenic\tExon\tIntron\t3_UTR\t5_UTR\tNonsynonymy\tSynonymy\n";

$max=int($max*20);
$min=int($min*20);
for(my $i=-1;$i<=19;$i++){
    my $k=$i/20;
    print OB "$k";
    print OA  "$k"; 
    for(my $j=0;$j<@type;$j++){
        my $fst=$fst{$type[$j]}{$k};
#		$fst=0 unless (defined $fst{$type[$j]}{$k});
        $fst=0 unless ($fst);
        print OA "\t$fst";
        $fst=$fst/$count{$type[$j]};
        print OB "\t$fst";
    }
    print OA "\n";
    print OB "\n";
}

close OA;
close OB;

sub read_file{
    my $file=shift;
    my $type=shift;
    open IN,$file or die "$!";
    while(<IN>){
        chomp;
        my @f=split;
        #$f[1]=sprintf("%.1f",$f[1]);
        
        my  $f=(int (20*$f[1]))/20;
        $f-=0.05 if($f[1]<0);
        $fst{$type}{$f}++;
        $count{$type}++;
        $min=($min>$f)?$f:$min;
        $max=($max<$f)?$f:$max;
    }
    close IN;
}

