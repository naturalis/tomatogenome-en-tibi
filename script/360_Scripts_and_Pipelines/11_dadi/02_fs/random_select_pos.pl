#!/usr/bin/perl -w
use strict;
use lib "/nas/RD_09C/resequencing/soft/lib/perl5/site_perl/5.8.5" ;
use Compress::Zlib ; 
#explanation:this program is edited to 
#edit by liuxin;   Thu Nov 29 09:56:02 CST 2012
#Version 1.0    liuxin@genomics.org.cn 
die  "Version 1.0\tt2012-11-29;\nUsage: $0 <InPut.gz>\n" unless (@ARGV == 1);		#lintao
#die  "Version 1.0\tt2012-11-29;\nUsage: $0 <InPut.gz><OUT>\n" unless (@ARGV == 1);		#liuxin

my $temp=(split(/\./,$ARGV[0]))[-1];
if ($temp ne "gz") 
{
    print "the input file must be #.gz\n";
    exit(1);
}

for(my $i=2;$i<=20;$i++)		#20 snp datasets
#for(my $i=1;$i<=100;$i++)
{

    my $gz=gzopen($ARGV[0],"rb") || die $!;

    `mkdir random$i`;
    open OT,">dadi.input" or die $!;

    $gz->gzreadline(my $info);
    $gz->gzreadline(my $title);
    print OT $info;
    print OT $title;


    my $num=1;
	
    while($gz->gzreadline($_) > 0) 
	{ 
        if(int(rand(11424352))<=500000 && $num<=500000)		#500,000 snps each , rand is snp number
#        if(int(rand(4380956))<=100000 && $num<=100000)
        {
            print OT "$_";
            $num++;
        }
	}
    $gz->gzclose();

    close OT;
    `/home/mudesheng/bin/python2.7 import_data2fs_tomato.py`;
    `mv dadi.input *.fs random$i`;
}

