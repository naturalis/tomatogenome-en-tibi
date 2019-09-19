perl Nonsense_mutation_position.pl ref.gff ../tomato_nonSynonymous.info > Nonsense_mutation.loci_raw
#awk '{if($11!~/->M;/) print $0}' Nonsense_mutation.loci_raw >Nonsense_mutation.loci_raw2
awk '{if($11~/M<->/) print $0}' Nonsense_mutation.loci_raw >Nonsense_mutation.start.loci
awk '{if($11~/->U/) print $0}' Nonsense_mutation.loci_raw >Nonsense_mutation.stop.loci
awk '{if($11~/U<->/) print $0}' Nonsense_mutation.loci_raw >Nonsense_mutation.elongated.loci
cat Nonsense_mutation.start.loci Nonsense_mutation.stop.loci Nonsense_mutation.elongated.loci >Nonsense_mutation.loci

python3 count_gene_from_nonsyn.py
