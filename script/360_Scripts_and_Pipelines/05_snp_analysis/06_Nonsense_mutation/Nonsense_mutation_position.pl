#!/usr/bin/perl
my $gff=shift;
my $info=shift;
open IN,$gff or die "$!";
my %loci;
while(<IN>){
	chomp;
	next unless (/CDS/);
	my @inf=split(/\t/,$_);
	my $id=$1 if($inf[8]=~/^ID=([^;]+);/);
	push @{$loci{$id}},[$inf[3],$inf[4],$inf[6],$inf[0]];
}
close IN;
my %hash;
foreach my $gene(keys %loci){
	my @loci=@{$loci{$gene}};
	@loci=sort {$a->[0]<=>$b->[0]}@loci;
	my $stand=$loci[0][2];
	if($stand eq '+'){
		my $lo=$loci[0][0];
#		print "$loci[0][3]\t$gene\t$lo\t$stand\n";
		$hash{"$loci[0][3]&$lo"}=1;
		$lo++;
#		print "$loci[0][3]\t$gene\t$lo\t$stand\n";
		$hash{"$loci[0][3]&$lo"}=1;
		$lo++;
#                print "$loci[0][3]\t$gene\t$lo\t$stand\n";
		$hash{"$loci[0][3]&$lo"}=1;
	}
	if($stand eq  '-'){
		my $lo=$loci[-1][1];
		$hash{"$loci[0][3]&$lo"}=1;
#		print "$loci[0][3]\t$gene\t$lo\t$stand\n";
                $lo--;
		$hash{"$loci[0][3]&$lo"}=1;
#                print "$loci[0][3]\t$gene\t$lo\t$stand\n";
                $lo--;
		$hash{"$loci[0][3]&$lo"}=1;
#                print "$loci[0][3]\t$gene\t$lo\t$stand\n";
	}
}




#=pod

open INFO,$info or die  "$!";
while(<INFO>){
	chomp;
	my @inf=split;
	if($inf[10]=~/U/){
		print "$_\n";
		next;
	}
	if($hash{"$inf[0]&$inf[1]"}){
		print "$_\n";
	}

}
close INFO;

