#!/usr/bin/perl
#use strict;
use Data::Dumper;
use lib "/share/fg4/lintao/soft/lib/perl5/site_perl/5.8.5" ;
use Compress::Zlib ;

die "perl $0 <individul_list> <stat_dir> <snp> <chr>\n" unless ($#ARGV==3);
my $individul_list=shift;
my $stat_dir=shift;
my $snp=shift;
my $chr=shift;

my %snp=read_snp($snp);

my $out="$chr.snp.stat";
my $out_temp="$chr.snp.stat.temp";
open OUT,">$out" or die "$!";
print OUT "chrome\tloci\n";
foreach my $lo(sort {$a<=>$b}keys %snp){
	print OUT "$chr\t$lo\n";
}
close OUT;


open IN,$individul_list or die  "$!";
while(<IN>){
	my @inf=split;	
	my $sample=(split(/\_/,$inf[2]))[0];
	my %stat=read_stat($sample,$chr);
	open IB,$out or die "$!";
	open OB,">$out_temp" or die "$!";
	my $head=<IB>;
	chomp $head;
	print OB "$head\t$inf[2]\n";
	while(<IB>){
		chomp;
		my @aa=split(/\t/,$_);
		my $stat="0_0_0_0";
		$stat=$stat{$aa[1]} if($stat{$aa[1]});
		print OB "$_\t$stat\n";
	}
	close IB;	
	close OB;
	`mv $out_temp $out`;
}
close IN;

sub read_stat{
	my $samp=shift;
	my $chr=shift;
	my $file="$stat_dir/$samp/$chr.stat.depth.fa.gz";
	my %hash;
	my $gz=gzopen($file,"rb") || die $!;
	while($gz->gzreadline($_) > 0){
		chomp;
		my @f=split(/\s+/,$_);
		my $lo=shift @f;
		$hash{$lo}=join("_",@f) if($snp{$lo});
	}
	$gz->gzclose();
	return %hash;
}

sub read_snp{
	my $file=shift;
	my %hash;
	open IN,$file or die "$!";
	while(<IN>){
		chomp;
		my @e=split;
		$hash{$e[1]}=1;
	}	
	close IN;
	return %hash;
}


