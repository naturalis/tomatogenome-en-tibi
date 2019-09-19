#!/usr/bin/perl
#use strict;
use Data::Dumper;
use lib "/nas/RD_09C/resequencing/soft/lib/perl5/site_perl/5.8.5" ;
use Compress::Zlib ;
use File::Basename;

my $ldout_dir=shift;
my $chr=shift;
my $bin=shift;
$bin ||=10;
my %count;
my %rr;
my $loci=$bin+1;
my $chr_loci=1;
my %before;
my %after;

my $info="$ldout_dir/$chr.info";
open INFO,$info or die "$!";


my $ldout="$ldout_dir/$chr.ped.LD.gz";
my $gz=gzopen($ldout,"rb") || die $!;
while($gz->gzreadline($_) > 0){
	chomp;
	next if(/Dist/);
	my @inf=split(/\s+/,$_);
	if($inf[0]>$loci){
		work();
		$loci=$inf[0];
	}
	next if ($inf[1]-$inf[0])>$bin;
	push @{$before{$inf[1]}},[$inf[0],$inf[4]];
	push @{$after{$inf[0]}},[$inf[1],$inf[4]];
}
$gz->gzclose();


sub work{
	my %be=%before;
	my %af=%after;
	%before=();
	%after=();
	my $st=$loci-$bin;
	my $en=$loci+$bin;
	#my @array; 
	for(my $i=$st;$i<=$en;$i++){
		$after{$i}=$af{$i} if(defined $af{$i});
		$before{$i}=$be{$i} if(defined $be{$i});
	}
	my @be=@{$before{$loci}};
	my @af=@{$after{$loci}};

	my $r2=0;
	my $num=2+$#be+$#af;
	for(my $j=0;$j<=$#be;$j++){
		$r2+=$be[$j][1];
	}
	for(my $k=0;$k<=$#af;$k++){
		$r2+=$af[$k][1];
	}
	if($num>0){
		my $check=1;
		while($check){
			my $line=<INFO>;
			chomp $line;
			my @info=split(/\s+/,$line);	
			if($info[0]>=$loci){
				$check=0;
				$chr_loci=$info[1];
			}
		}
		$r2=$r2/$num;
		print "$chr\t$chr_loci\t$loci\t$r2\n";
	}
}






