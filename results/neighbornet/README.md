NeighborNet analysis
====================

Producing input files
---------------------

The input files are produced thusly with the Perl script
[make_structure_table.pl](https://github.com/naturalis/tomatogenome-en-tibi/blob/master/script/make_structure_table.pl)

In addition, it needs access to the SQLite database file `EnTibiBasesRemapped.db` from the
`snpdb.zip` archive.

```

make_structure_table.pl -o phy -v -d EnTibiBasesRemapped.db > bases.phy

```

As it turns out, the SNPs database contains some accessions that we are not really 
interested because they are more distal species. We manually removed the following 
accessions:

- TS.407
- TS.208
- TS.408
- TS.199
- TS.207
- TS.217
- TS.403
- TS.402
- TS.404
- TS.146

SplitsTree analysis
-------------------

This step refers to operations on the file `bases.phy` in SplitsTree4 v4.15.1 for Mac OSX.

In SplitsTree we select `Distances > K2P` to correct distances using the Kimura 2-param
substitution model, with a transition : transversion ratio of 2.0. From the characters
we remove all autapomorphies, i.e. `Data > Exclude Parsimony-Uninformative Sites`. The
network is a neighbornet (`Networks > NeighborNet`). These settings are embedded in a
command block at the bottom of the output file `bases.phy.nex`, so reopening this file
in SplitStree should recover these settings automatically.

Using the graphical interface, we reorient the graph and its terminal edges to reduce 
branch and label overlaps and optimize for landscape orientation of the main graph and
and portrait for the zoomed subgraph surrounding the _En Tibi_ specimen. Exporting at
two different zoom levels produces the files:

- `bases.phy.overview.svg`
- `bases.phy.zoom.svg`