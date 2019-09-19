#!/usr/bin/perl

my $list=shift;
my $dir=shift;
my $chr=shift;

open IN,$list or die "$!";
my @list;
my $depth;
while(<IN>){
	chomp;
	my @f=split;
	push @list,$f[1];
	$depth{$f[1]}=$f[3];
}

#Indel_37.list
my %indel;
for (my $i=0;$i<=$#list;$i++){
	my $indel="$dir/Indel_$list[$i].list";
	my $dep=$depth{$list[$i]};
	$dep_min=0.5*$dep;
	$dep_max=2*$dep;
	open IN,$indel or die "$!";
	while(<IN>){
		chomp;
		my @e=split;
		next if($e[0] ne $chr);
		next if($e[8]<$dep_min || $e[8]>$dep_max);
		$e[2]=~s/D/-/;
		$e[2]=~s/I/+/;
		$indel{$e[1]}{$list[$i]}=$e[2];
	}
	close IN;
}
open OUT,">$chr.len" or die "$!";
foreach my $loci(sort {$a<=>$b} keys %indel){
	print "$chr\t$loci\t";
	my @aa;
	my %check;
	for (my $i=0;$i<=$#list;$i++){
		my $ind=$indel{$loci}{$list[$i]};
		$ind=0 unless ($ind);
		push @aa,$ind;
		$check{$ind}=1 if($ind != 0);
	}
	print join(" ",@aa),"\n";
	my @key=keys %check;
	if($#key==0){
		print OUT "$chr\t$loci\t$key[0]\n";
	}
}
close OUT;

