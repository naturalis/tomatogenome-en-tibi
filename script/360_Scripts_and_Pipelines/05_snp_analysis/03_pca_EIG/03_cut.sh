less tomato.pca.evec  |awk '{print $1"\t"$2"\t"$3"\t"$12}' > tomato.pca.evec.cut
grep \pimp tomato.pca.evec.cut > tomato.pca.evec.cut.pimp
grep \ceris tomato.pca.evec.cut > tomato.pca.evec.cut.ceris
grep \big tomato.pca.evec.cut > tomato.pca.evec.cut.big
grep \abnormal tomato.pca.evec.cut > tomato.pca.evec.cut.abnormal
