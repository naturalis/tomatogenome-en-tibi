#!/usr/bin/perl
use File::Basename;

my $stat=shift;

my $stat_name =basename $stat;
my $chr=(split(/\./,$stat_name))[0];

mkdir  $chr unless (-d $chr);
open IN,$stat or die "$!";
my $head=<IN>;
chomp $head;
my $count=0;
my $id=1;
my @array;

open SH,">$chr/$chr.work_qsub.sh" or die "$!";
while(<IN>){
	chomp;

	push @array,$_;
	$count++;
	if($count==100000){
		open OUT,">$chr/$chr.$id.stat";
		print OUT $head,"\n";
		for(my $i=0;$i<=$#array;$i++){
			print OUT $array[$i],"\n";
		}
		close OUT;
		my $sh="$chr/$chr.$id.sh";
		open S,">$sh" or die "$!";
		print S "date\nperl ../chisq.test.pl $chr.$id.stat /share/fg4/lintao/tomato/05_base_depth_stat/Total_chisq.test_split/raw/$chr.raw $chr.$id.out\ndate\n";
		close S;
		print SH "qsub  -P pc_pa_us -q st_pc.q  -S /bin/sh -cwd -l vf=0.3G  $chr.$id.sh\n";
		$id++;
		$count=0;
		@array=();
	}
}
close IN;
if($#array>=0){
	open OUT,">$chr/$chr.$id.stat";
	print OUT $head,"\n";
	for(my $i=0;$i<=$#array;$i++){
		print OUT $array[$i],"\n";
	}
	close OUT;
}
@array=();

my $sh="$chr/$chr.$id.sh";
open S,">$sh" or die "$!";
print S "date\nperl ../chisq.test.pl $chr.$id.stat /share/fg4/lintao/tomato/05_base_depth_stat/Total_chisq.test_split/raw/$chr.raw  $chr.$id.out\ndate\n";
close S;
print SH "qsub  -P pc_pa_us -q st_pc.q  -S /bin/sh -cwd -l vf=0.3G  $chr.$id.sh\n";


close SH;


