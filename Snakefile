data = "~/Dropbox/documents/projects/dropbox-projects/tomato/data"

fastp -i $in1 -I $in2 -o $out1 -O $out2 -j ${stem}.json -h ${stem}.html -a $adaptor --verbose --dont_overwrite 2> ${stem}.log

minimap2 -d ${staged_ref_file}.mmi -t ${threads} ${staged_ref_file}

minimap2 -ax sr -a -t $threads $staged_ref_file $staged_r1 $staged_r2 > ${tmp_stem}.sam

samtools view -b -u -F 0x04 --threads %i -o %s %s # out, in

samtools fixmate -r -m  --threads %i %s %s # in, out

samtools sort -l 0 -m 7G --threads %i -o %s %s # out, in

samtools markdup -r --threads %i %s %s # out, in

