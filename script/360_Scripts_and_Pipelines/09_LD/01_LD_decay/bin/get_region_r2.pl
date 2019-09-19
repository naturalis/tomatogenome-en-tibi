#!/usr/bin/perl
use FindBin qw($Bin);
use Data::Dumper;

my $region=shift;
my $cult_dir=shift;
my $wild_dir=shift;





open RE,$region or die  "$!";
while(<RE>){
	chomp;
	my @f=split;
	my $LD_cult="$cult_dir/$f[0].ped.LD";
	my $info_cult="$cult_dir/$f[0].info";

	my $LD_wild="$wild_dir/$f[0].ped.LD";
	my $info_wild="$wild_dir/$f[0].info"


	my %r2_cult=get_r2($LD_cult,$info_cult,$_);
	my %r2_wild=get_r2($LD_wild,$info_wild,$_);
	

	foreach my $dis (sort {$a<=>$b } keys %r2_cult){
		print  "$dis\t$r2_cult{$dis}\t$r2_wild{$dis}\n" if($r2_wild{$dis}>-1);		
	}
	print Dumper \%r2;




#	exit;
}
close RE;


sub get_r2{
	my $LD=shift;
	my $info=shift;
	my $line=shift;;
	my @f=split(/\s+/,$line);
	my %hash;

	my $id=`cat $info |awk '\$2>=$f[1] && \$2<=$f[2]' |cut -f 1`;
	print  $id,"\n";
	my @id=split(/\s+/,$id);
	for my $i(@id){
		$hash{$i}=1;
	}
#	print Dumper \%hash;


	open IN,$LD or die  "$!";
	my $out="LD.temp";
	open OUT,">$out" or die  "$!";
	my $head=<IN>;
	print OUT $head;
	while(<IN>){
		chomp;
		my @e=split;
		print OUT "$_\n" if($hash{$e[0]} && $hash{$e[1]});
	}
	close IN;
	close OUT;
	`perl $Bin/filter_stat.pl  LD.temp > info.temp`;
	`perl $Bin/combine.pl info.temp |perl $Bin/combine_points.pl - 10 > decay.temp`;
	open DE,"decay.temp" or die  "$!";
	my %out;
	while(<DE>){
		chomp;
		my @h=split;
		$out{$h[0]}=$h[1];
	}
	close DE;
	return %out;
}

