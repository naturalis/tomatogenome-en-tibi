#!/usr/bin/perl
my $genotype=shift;
my %homo=(
	'A'=>'1',
	'T'=>'1',
	'C'=>'1',
	'G'=>'1',
);

print "Chrome\tloci\tallele_eq_ref\tallele_ne_ref\thete\tmissing\ttotal\thete_rate\thete_muti\n";
open IN,$genotype or die "$!";
while(<IN>){
	chomp;
	my @inf=split;
	my $ref=$inf[2];
	my $allele_eq_ref=0;
	my $allele_ne_ref=0;
	my $hete=0;
	my $missing=0;
	for(my $i=3;$i<=$#inf;$i++){
		if($inf[$i] eq '-'){
			$missing++;
			next;
		}
		if(!$homo{$inf[$i]}){
			$hete++;
			next;
		}
		if($inf[$i] eq $ref){
			$allele_eq_ref++;
			next;
		}
		$allele_ne_ref++;
	}
	my $total=$missing+$hete+$allele_eq_ref+$allele_ne_ref;
	my $sum=$hete+$allele_eq_ref+$allele_ne_ref;
	my $hete_rate=0;
	if($sum){
		$hete_rate=$hete/$sum;
	}
	my $min=($allele_eq_ref<$allele_ne_ref)?$allele_eq_ref:$allele_ne_ref;
	my $hete_muti='NA';
	$hete_muti=$hete/$min if($min);
	print "$inf[0]\t$inf[1]\t$allele_eq_ref\t$allele_ne_ref\t$hete\t$missing\t$total\t$hete_rate\t$hete_muti\n";
}
close IN;

