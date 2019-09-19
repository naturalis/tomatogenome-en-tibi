tail -n 3794 all_ratio_sort.poly >top_5_sort.poly
sort -k 1,1 -k 2,2n top_5_sort.poly >top_5_chr_pos_sort.poly
awk '{if($6>=200) print $0}' top_5_chr_pos_sort.poly >top_5_chr_pos_sort_filter.poly
python3 count_top_percent_5_pi_region.py
awk '{print $1,$2,$3,$6,$10}' all_ratio.poly >all_only_pi.poly
