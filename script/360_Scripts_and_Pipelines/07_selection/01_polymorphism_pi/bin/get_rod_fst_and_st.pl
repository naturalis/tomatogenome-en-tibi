#!/usr/bin/perl

use File::Basename;

my $dir=`pwd`;
my $file_name=basename $dir;

my $cut_off=shift;
$cut_off ||=0.975;

chomp $dir;
mkdir "$dir/select" unless (-d "$dir/select");
`cat ch*/*.poly >$dir/select/all.poly`;

my @aa=split(/\_/,$file_name);
my $out_file="$dir/select/$aa[0]\_rod_fst";
open OUT,">$out_file" or die "$!";

my $count;
my $mean;


open IN,"$dir/select/all.poly" or "$!";
while(<IN>){
        chomp;
        next if($_=~/NA/);
        my @f=split;
        next unless ($#f==8);
        $mean+=$f[8];
        $count++;
#       next unless ($_[1]%5000==0);
        next if($f[5]==0);
        my $rod=1-$f[2]/$f[5];
        print OUT "$rod\t$f[8]\t$f[0]\t$f[1]\t$f[5]\t$f[2]\n";
}
#print OUT "0\t0\n";

close IN;
close OUT;
$mean=$mean/$count;
print "$count\t$mean\n";


my $r_file="$out_file.R";

open R,">$r_file" or die "$!";
print R "read.table(\"$out_file\")->ch
ch\$V2[ch\$V1>=0 & ch\$V2>=0]->yy
ch\$V1[ch\$V1>=0 & ch\$V2>=0]->xx
hist(yy,breaks=100,plot=F)->hy
hist(xx,breaks=100,plot=F)->hx
quantile(xx,probs=$cut_off)->xa
xa
quantile(yy,probs=$cut_off)->yb
yb
write(xa,file=\"rod_fst\",append =TRUE)
write(yb,file=\"rod_fst\",append =TRUE)
pdf(\"$aa[0]\_selection.pdf\")
plot(yy~xx,cex=0.5,pch=4,col=\"blue\",xlim=c(0,1.2),ylim=c(0,1.2),xlab=\"RoD\",ylab=\"Fst\",axes=FALSE);
barplot(axes=FALSE,hx\$density/20,offset=1,add=T,space=0,width=0.01,col=\"green\");
barplot(axes=FALSE,horiz=T,hy\$density/20,offset=1,add=T,space=0,width=0.01,col=\"red\");
lines(c(yb,yb)~c(0,1));lines(c(0,1)~c(xa,xa));axis(side=1,at=c(0,0.2,0.4,0.6,0.8,1));
axis(side=2,at=c(0,0.2,0.4,0.6,0.8,1))
dev.off()
q()\n";
close R;
`R < $r_file --vanilla`;

open IN,"rod_fst" or die "$!";
my ($rod,$fst);
while(<IN>){
	chomp;
	$rod=$_;
	$fst=<IN>;
	chomp $fst;
}
close IN;
print "$rod\t$fst\n";
