#/usr/bin/perl -w
use strict;
#use Cwd;
#my $curcwd = getcwd();

my $out_put_dir=shift; #absulute path

for (my $i = 1;$i<=13;++$i) {
	open(OUT,">WSNPChr${i}.sh") or die $!;
	print OUT "date\n";
	my $cmd1 = "perl /share/fg4/lintao/tomato/04_snp/00_bin/Addcn_All_gz.pl  -input  /share/fg4/lintao/tomato/04_snp/02_Raw/Chr${i}.raw  -list  $out_put_dir/list/Chr${i}.soap.list   -chr   Chr${i}    -output $out_put_dir/Chr${i}";
	print OUT $cmd1,"\n";
	my $cmd2 = "perl /share/fg4/lintao/tomato/04_snp/00_bin/filter_Raw.pl -input  $out_put_dir/Chr${i}.add_cn  -output $out_put_dir/Chr${i}";
	print OUT $cmd2,"\n";
	my $cmd3 = "python  /share/fg4/lintao/tomato/04_snp/00_bin/GLF2GPF.py  $out_put_dir/Chr${i}.dbsnp  /share/fg4/lintao/tomato/04_snp/01_GLT_OUT/list/Chr${i}.list  $out_put_dir/Chr${i}.temp";
	print OUT $cmd3,"\n";
	my $cmd4 = "perl  /share/fg4/lintao/tomato/04_snp/00_bin/new_genotype.pl  $out_put_dir/Chr${i}.temp   $out_put_dir/Chr${i}.genotype";
	print OUT $cmd4,"\n";
	print OUT "date\n";
	close OUT;
}

