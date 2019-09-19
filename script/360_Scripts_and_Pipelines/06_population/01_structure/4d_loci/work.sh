perl loci_4d.pl  rep.gff  tomato.cds > tomato.cds.4d
grep \SL2.40ch01 tomato.cds.4d > SL2.40ch01.out
perl cut_seq.pl SL2.40ch01.out SL2.40ch01.fa  >  SL2.40ch01.fa.cut &
cat SL2.40ch01.fa.cut  |perl -e '{while(<>){chomp;my @f=split;print $_,"\n" if($f[3] ne $f[6])}}' 
