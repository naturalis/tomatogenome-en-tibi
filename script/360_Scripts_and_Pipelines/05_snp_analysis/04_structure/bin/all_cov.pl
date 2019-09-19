#!/usr/bin/perl-w
use strict;
#explanation:this program is edited to 
#edit by HeWeiMing;   Sun Oct 31 20:28:03 CST 2009
#Version 1.0    hewm@genomics.org.cn 

die "Version 1.0\t2009-10-31;\nUsage: $0 <add_ref.list><Out>\n" unless (@ARGV ==2);

#############Befor  Start  , open the files ####################

Multi_file_s ($ARGV[0],$ARGV[1]);

######################swimming in the sky and flying in the sea ###########################
sub Multi_file_s {
    my $filelist= shift ;
    my $outPut=shift ;
    open (Flist , "<$filelist") || die "$!" ;
    open (OUT , ">$outPut") || die "$!" ;
    while ($_=<Flist>)
    {
        chomp ;
        my $file=$_ ;
        open Fi ,"$file" || die "$!" ;
        while ($_=<Fi>)
        {
            chomp ;
            my @inf=split ;
            my $aa=join(" ",@inf[2..$#inf]);
            next if ($aa =~ /-/);
            print OUT "$inf[0]\t$inf[1]\t$aa\n";
        }
        close Fi ;
    }
    close Flist ;
    close OUT;
}

