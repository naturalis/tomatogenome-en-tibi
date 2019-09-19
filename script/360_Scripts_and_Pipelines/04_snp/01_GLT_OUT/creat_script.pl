#/usr/bin/perl -w
use strict;
use Cwd;

my $curcwd = getcwd();
my $sample_dir = $ARGV[0];# Absolute Path
opendir(DH,$sample_dir) or die $!;
foreach my $file (readdir DH) {
	if(-d ${sample_dir}."/$file" && $file =~ /\w+/){
		`mkdir $file`;
		chdir $file;
		for (my $i = 1;$i<=13;++$i) {
			open(OUT,">WC${file}_Chr${i}.sh") or die $!;
			print OUT "date\n";
			my $cmd = "gzip -d $sample_dir/$file/Chr${i}.sort.gz\n/share/fg4/lintao/bin/SOAPsnp-v1.02/soapsnp  -i  $sample_dir/$file/Chr${i}.sort -d   /share/fg4/lintao/tomato/01_reference/SL2.40ch${i}.fa   -L   100   -u  -F   1   -o  SL2.40ch${i}.glf   -M   Chr${i}.mat\ngzip $sample_dir/$file/SL2.40ch${i}.sort";
			print OUT $cmd,"\n";
			print OUT "rm SL2.40ch${i}.mat\n";
			print OUT "date\n";
			close OUT;
		}
		print OUT "date\n";
		close OUT;
	}
	chdir $curcwd;
}
closedir(DH);
