seqboot <seqboot_params
mv outfile infile1
dnadist <dnadist_params
mv outfile infile2
neighbor <neighbor_params
mv outfile outfile1
mv outtree intree1
consense <consense_params
./change_individual_ID.py -i1 subpop_wild_tree.list -i2 outtree -o outtree_change.tre
