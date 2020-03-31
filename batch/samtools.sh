#! /bin/bash

#SBATCH --job-name=samtools
#SBATCH --output=output_samtools.txt


#echo "Correct mate pairs"
#samtools \
#        fixmate -r -m  \
#        --threads 4 \
#        "paired_En-Tibi.bam" \
#        "paired_En-Tibi.fixmate.bam"

#echo "Sort the reads"
#samtools \
#  sort -l 0 \
#  -m 3G \
#  --threads 4 \
#  -o "paired_En-Tibi.fixmate.sorted.bam" "paired_En-Tibi.fixmate.bam"

echo "Mark duplicates"
samtools \
  markdup -r \
  --threads 4 \
  "paired_En-Tibi.fixmate.sorted.bam" \
  "paired_En-Tibi.fixmate.sorted.markdup.bam"


