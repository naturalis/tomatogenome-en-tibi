cat *Fst >all.Fst
less all.Fst | grep -v e >all_e.Fst
sort -k 3,3n all_e.Fst >all_e.sort.Fst

sleep 5s; tail -n 3638 all_e.sort.Fst >fresh_process.top_5.Fst		#3638 is window number (top 5 )		because file has "e", such as 1e-4
sleep 5s; sort -k 1.3n -k 2,2n fresh_process.top_5.Fst >fresh_process.top_5.sort.Fst		#chromosome and position sort
sleep 5s
../../../bin/count_top_percent_5_divergence_region.py -i fresh_process.top_5.sort.Fst -o fresh_process.divergence_region
