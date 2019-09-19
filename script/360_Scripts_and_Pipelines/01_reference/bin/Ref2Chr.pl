#!/usr/bin/perl-w
use strict;
#explanation:this program is edited to 
#edit by HeWeiMing;
die  "Version 1.0 2009-5-20;\nUsage: $0 <InPut.fa>\n" unless (@ARGV == 1);
open	 (A,"$ARGV[0]")  || die "$!" ;
$/=">";
<A>;
	while(<A>) 
	{ 
		chomp ;
		my @inf=split /\n/;
		my $chr=(split(/\s+/ ,$inf[0]))[0] ; 
        open (B,">$chr\.fa") || die "$!";
		print B  ">",$_;
		close B;
	}
close A;
$/="\n";
