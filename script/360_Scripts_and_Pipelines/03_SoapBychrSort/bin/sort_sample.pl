#!/usr/bin/perl -w
use strict;
use Cwd;

my $curcwd = getcwd();
my $sample = $ARGV[0];
my $soap_dir=$ARGV[1];
my %samplehash;
open(IN,$sample) or die $!;
while (<IN>) {
	chomp;
	my ($sample,$fq_name)=(split(/\t/,$_))[0,2];
	my $dir_name = (split(/\./,(split(/\//,$fq_name))[-1]))[0];
	$dir_name =~ s/_1$//;
	push @{$samplehash{$sample}},$dir_name;
}
close IN;
foreach my $key (keys %samplehash) {
	`mkdir $key`;
	chdir $key;
	open(OUT,">WD$key.sh") or die $!;
	print OUT "date\n";
	for (my $i = 1;$i<=13;++$i) {
		foreach my $tmp (@{$samplehash{$key}}) {
			my $cmd1 = "ls $soap_dir/${tmp}/SoapBychrSort/Chr${i}.dedup >> $curcwd/$key/Chr${i}.list";
			print OUT $cmd1,"\n";
		}
		my $cmd2 = "python3 /share/fg4/lintao/tomato/03_SoapBychrSort/CatSoapSort.py $curcwd/$key/Chr${i}.list > $curcwd/$key/Chr${i}.sort\n";
		print OUT $cmd2,"\n";
	}
	print OUT "date\n";
	close OUT;
	chdir $curcwd;
}
