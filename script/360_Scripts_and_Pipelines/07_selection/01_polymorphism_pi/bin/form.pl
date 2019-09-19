#!/usr/bin/perl

use File::Basename;

my $dir=`pwd`;
chomp $dir;
my $dir_name=basename $dir;

open SI,$ARGV[0] or die "$!";
my %size;
while(<SI>){
	chomp;	
	my @f=split;
	$size{$f[0]}=$f[1];
}
close SI;


for(my $i=1;$i<=13;$i++){
	$i="0" if($i==13);
	mkdir "ch$i" unless (-d "ch$i");
	my $sh="ch$i/$dir_name.ch$i.sh";
	my $size=$size{"ch$i"};
	open SH,">$sh" or die "$!";
	if ($i<10) {
	print SH "perl ../sliding.pl /share/fg3/lintao/solab/lintao/tomato/XP_CLR/ch0$i.final.genotype $size chr$i.poly\n";
	}
	else {
	print SH "perl ../sliding.pl /share/fg3/lintao/solab/lintao/tomato/XP_CLR/ch$i.final.genotype $size chr$i.poly\n";
	}
	close SH;
	print "cd ch$i\nqsub -cwd -l vf=0.6G $dir_name.ch$i.sh\ncd ..\n";
	last if($i=="0");
}



