use warnings;
use strict;
use Bio::PopGen::IO;
use Bio::PopGen::Statistics;
use Bio::PopGen::PopStats;
my $stats1= Bio::PopGen::Statistics->new();
my $stats2=Bio::PopGen::PopStats->new();
my $ioc = Bio::PopGen::IO->new(-format => 'csv',
		-file => 'c.csv');
my $iow = Bio::PopGen::IO->new(-format => 'csv',
		-file => 'w.csv');

###################################
#Get and output window information.
open IN,"info.txt";
my $info=<IN>;
my @tmp=split(/\t/,$info);
my $chr=shift(@tmp);
my $pos=shift(@tmp);
#my $aa=join(",",@tmp);print "$aa\n";
#print "$chr\t$pos";
###################################
##################################
#Caculate and output pi theta tajimaD fuliD* fuliF* in C and W populations separately
my ($out1,$out2);


my $pop1=Bio::PopGen::Population->new();
my $pop2=Bio::PopGen::Population->new();
if( $pop1 = $ioc->next_population ) {
	my $pi = $stats1->pi($pop1);
	my $theta = $stats1->theta($pop1);
	my $tajimad=$stats1->tajima_D($pop1);
#	my $flds=$stats1->fu_and_li_D_star($pop1);
#	my $flfs=$stats1->fu_and_li_F_star($pop1);
#	print "pi theta tajimaD fuliD* fuliF*\n$pi $theta $tajimad $flds $flfs\n";
#    print "\t$pi $theta $tajimad";
	$out1="$pi $theta $tajimad";
#    print "\t$pi $theta $tajimad $flds $flfs";
}

if( $pop2 = $iow->next_population) {
	my $pi = $stats1->pi($pop2);
	my $theta = $stats1->theta($pop2);
	my $tajimad=$stats1->tajima_D($pop2);
#	my $flds=$stats1->fu_and_li_D_star($pop2);
#	my $flfs=$stats1->fu_and_li_F_star($pop2);
#	print "\t$pi $theta $tajimad\t";
	$out2="$pi $theta $tajimad";
#	print "\t$pi $theta $tajimad $flds $flfs";
}
##################################
#####################################
#Caculate Fst
#my @populations;
#push(@populations,$pop1);
#push(@populations,$pop2);
#my @markernames=@tmp;
#my $fst = $stats2->Fst(\@populations,\@markernames);
#print "$chr\t$pos\t$out1\t$out2\t$fst\n";
print "$chr\t$pos\t$out1\t$out2\n";
#####################################
