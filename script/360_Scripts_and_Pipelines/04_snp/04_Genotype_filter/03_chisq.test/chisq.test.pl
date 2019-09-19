#!/usr/bin/perl
use File::Basename;
die "perl $0 <stat> <raw> <result>\n" unless ($#ARGV==2);
my $stat=shift;
my $raw=shift;
my $result=shift;



my %genotype=(
	'A'=>'0',
	'C'=>'1',
	'T'=>'2',
	'G'=>'3',
);
my $stat_name=basename $stat;
my $r="$stat.R";
my $temp_stat="$stat_name.temp";
open R,">$r" or die "$!";


print R "read.table(\"$temp_stat\")->da\n";
#print R "da\$V2->x\n";
#print R "da\$V3->y\n";
print R "chisq.test(da,simulate.p.value=T,B=1000)\n";
print R "q()\n";
close R;
open IN,$stat or die "$!";
open RA,$raw or die  "$!";
open OR,">$result" or die  "$!";
my $head=<IN>;
chomp $head;
my @head=split(/\t/,$head);
my $loci;
while(<IN>){

	chomp;
#	print $_,"\n";
	my @inf=split;
	$loci=$inf[1];
	my $check=1;
	my $allele1;
	my $allele2;
	while($check){
		my $line=<RA>;
#		print "$line\n";
		chomp $line;
		my @line=split(/\t/,$line);
		if($line[1] eq $loci ){
			$check=0;
			if($line[2] eq $line[5]){
				($allele1,$allele2)=($line[5],$line[6]);
				next;
			}
			if($line[2] eq $line[6]){
				($allele1,$allele2)=($line[6],$line[5]);
				next;
			}
			($allele1,$allele2)=($line[5],$line[6]);
		}
	}
	open OA,">$temp_stat" or die  "$!";
	my $check=0;
	my $index=$genotype{$allele1};
	#print OA "$allele1\t$index\n";
	my $AA;
	my $BB;
	for(my $i=2;$i<=$#inf;$i++){
		my @f=split(/\_/,$inf[$i]);
		my $aa=$f[$index];
		my $sum;
		for(my $j=0;$j<=$#f;$j++){
		#	next if($j == $index);
			$sum+=$f[$j];
		}
	#	print OA "$inf[$i]\t$aa\t$sum\t";
		next if($sum==0);
	#	$aa=$aa/$sum;
		#$aa=int(100*$aa/$sum);
		#$aa=$aa/100;
		my $bb=$sum-$aa;
		print OA "$aa\t$bb\n";
		$AA+=$aa;
		$BB+=$bb;
		$check=1;
	}
	close OA;
		
	next unless ($check);
	if($AA==0 || $BB==0){
		print OR "$inf[0]\t$inf[1]\tNA\t$AA\t$BB\n";
		next;
	}
	my $R_out=`/opt/blc/genome/biosoft/R/bin/R < $r --vanilla` ;
	my @R_out=split(/\s+/,$R_out);
#	$R_out[-3]=0 if($R_out[-3] eq 'NA');
	print OR "$inf[0]\t$inf[1]\t$R_out[-3]\t$AA\t$BB\n";
#	die ;

}
close IN;
