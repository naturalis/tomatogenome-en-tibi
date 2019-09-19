#!/usr/bin/perl
use Data::Dumper;
open IN,$ARGV[0] or die "$!";
my %hash;

while(<IN>){
	chomp;
	my @f=split;
#	$_[0]=~s/\D+//g;
	#print "$_[0]\n";
	$f[1]=0 if($f[1]<0);
	push @{$hash{$f[0]}},[$f[2],$f[3],$f[5],$f[1],$f[4]];

}
close IN;
#print Dumper \%hash;

open FA,$ARGV[1] or die "$!";
$/=">";
while(<FA>){
	chomp;	
	my ($id,$seq)=split(/\n/,$_,2);
	my @aa=split(/\s+/,$id);
	next unless ($hash{$aa[0]});
	my @bb=@{$hash{$aa[0]}};
#	print "$aa[0]\n";

	$seq=~s/\s+//g;
	for my $cc(@bb){
		my @cc=@$cc;

#		my $line=substr($seq,$cc[0]-3,3);
		my $line=substr($seq,$cc[0]-1,1);	
		if($cc[1] eq '-'){
			$line=substr($seq,$cc[0]-1,1);
			$line=~tr/ATCGatcg/TAGCtagc/;
	                $line=reverse $line;
		}
		print  "$aa[0]\t",join("\t",@cc),"\t",$line,"\n";
	}
}
close FA;
