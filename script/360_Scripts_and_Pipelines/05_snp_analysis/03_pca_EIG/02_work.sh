#less individual.txt | perl -e '{while(<>){chomp;my @aa=split;my @bb=split(/\_/,$aa[2]);print "SAMPLE$aa[0]\tU\t$bb[1]\n";}}' > cucumber.ind
less individual.txt | perl -e '{while(<>){chomp;my @aa=split;if($aa[2] =~ /big/ or $aa[2] =~ /pimp/ or $aa[2] =~ /ceris/ or $aa[2] =~ /abnormal/) {print "SAMPLE$aa[0]\tU\t$aa[2]\n";}}}' > tomato.ind


cat Chr*.geno > tomato.geno
cat Chr*.snp > tomato.snp

perl bin/smartpca.perl  -m 0 -i tomato.geno -a tomato.snp -b tomato.ind -o tomato.pca  -p tomato.plot -e tomato.eval -l tomato.log   

/share/fg3/lintao/solab/lintao/tomato/06_snp_analysis/03_pca_EIG/EIG5.0.1/bin/twstats  -t /share/fg3/lintao/solab/lintao/tomato/06_snp_analysis/03_pca_EIG/EIG5.0.1/POPGEN/twtable  -i tomato.eval -o tomato.out &
