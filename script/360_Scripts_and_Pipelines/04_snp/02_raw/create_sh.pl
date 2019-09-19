#/usr/bin/perl -w
use strict;
#use Cwd;
#my $curcwd = getcwd();

my $dir=`pwd`;
chomp $dir;

for (my $i = 1;$i<=13;++$i) {
        open(OUT,">Chr${i}.sh") or die $!;
        print OUT "date\n";
        my $cmd = "//share/fg4/lintao/bin/SNP/GLFmultiv2  $dir/SL2.40ch${i}.list  $dir/SL2.40ch${i}.raw";
        print OUT $cmd,"\n";
        print OUT "date\n";
        close OUT;
}
close OUT;

