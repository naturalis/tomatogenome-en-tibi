Heterozygosity
==============

Generated an input file from the [bases.str](../structure/bases.str.gz) and the
SQLite [database](http://doi.org/10.5281/zenodo.4966843) using the script
[heterozygosity.pl](../../script/heterozygosity.pl):

```
perl -Ilib script/heterozygosity.pl \
    -b ~/Desktop/bases.str \
    -d ~/Desktop/EnTibiBasesRemapped.db \
    -v > results/heterozygosity/h.tsv
```

Then [relabeled](https://github.com/naturalis/tomatogenome-en-tibi/commit/f8b29215be3f70304d19f84b119ce2e2287e232b?branch=f8b29215be3f70304d19f84b119ce2e2287e232b&diff=split) the `status` column and added a 
[region](https://github.com/naturalis/tomatogenome-en-tibi/commit/a5a3e357362e87a304aa6990d399acf90f3ca1fd)
column.

Then generated plots in [R](heterozygosity.Rmd).