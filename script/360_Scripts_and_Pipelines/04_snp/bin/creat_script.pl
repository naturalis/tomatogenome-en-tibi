#/usr/bin/perl -w
use strict;
use Cwd;

my $curcwd = getcwd();
my $sample_dir = $ARGV[0];# Absolute Path
opendir(DH,$sample_dir) or die $!;
foreach my $file (readdir DH) {
	if(-d ${sample_dir}."/$file" && $file =~ /\w+/){
		my $file_U="$sample_dir/$file/ChrU.sort.gz";
		next unless (-e $file_U);
		`mkdir $file`;
		chdir $file;
		for (my $i = 1;$i<=7;++$i) {
			open(OUT,">WC${file}_Chr${i}.sh") or die $!;
			print OUT "date\n";
			my $cmd = "gzip -d $sample_dir/$file/Chr${i}.sort.gz\n/share/project005/xuxun/heweiming/bin/SOAPsnp-v1.02/soapsnp  -i  $sample_dir/$file/Chr${i}.sort -d   /ifs1/ST_PLANT/USER/zengpeng/Cucumber/01_ref_cultivated/Chr${i}.fa   -L   100   -u  -F   1   -o  Chr${i}.glf   -M   Chr${i}.mat\ngzip $sample_dir/$file/Chr${i}.sort";
			print OUT $cmd,"\n";
			print OUT "rm Chr${i}.mat\n";
			print OUT "date\n";
			close OUT;
		}
		open(OUT,">WC${file}_ChrU.sh") or die $!;
		print OUT "date\n";
		my $cmd = "gzip -d $sample_dir/$file/ChrU.sort.gz\n/share/project005/xuxun/heweiming/bin/SOAPsnp-v1.02/soapsnp  -i  $sample_dir/$file/ChrU.sort.gz -d   /ifs1/ST_PLANT/USER/zengpeng/Cucumber/01_ref_cultivated/ChrU.fa   -L   100   -u  -F   1   -o  ChrU.glf   -M   ChrU.mat\ngzip $sample_dir/$file/ChrU.sort";
		print OUT $cmd,"\n";
		print OUT "rm ChrU.mat\n";
		print OUT "date\n";
		close OUT;
	}
	chdir $curcwd;
}
closedir(DH);
