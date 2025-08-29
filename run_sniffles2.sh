#!/bin/bash

snf2_mod="/home/lpaz/Documents/baylor/hackathon/Sniffles/src/sniffles2_mod"

. /home/lpaz/bin/miniconda3_23_1_py10/etc/profile.d/conda.sh

ver="v9"
out="mosaic_snf2_calls_vaf1_100_Q20"
conda activate snf2dev

${snf2_mod} \
    --input mosaic_data_chr21_Q20.bam \
    --vcf   ${ver}/${out}.vcf.gz \
    --snf   ${ver}/${out}.snf \
    --threads 1 \
    --contig chr21 \
    --reference chr21.fasta.gz \
    --mapq 18 \
    --minsvlen 50 \
    --minsupport 3 \
    --mosaic-af-min 0.01 \
    --mosaic-include-germline \
    --output-rnames \
    --no-qc \
    --sample-id mosaic

bcftools view --include "(SVTYPE = 'DEL' || SVTYPE = 'INS') && (SVLEN <= 50000 && SVLEN >= -50000)" \
    ${ver}/${out}.vcf.gz  | \
    bgzip -c > ${ver}/${out}_INDELS_noqc.vcf.gz
bcftools index --tbi ${ver}/${out}_INDELS_noqc.vcf.gz

bcftools view --include "(SVTYPE = 'DEL' || SVTYPE = 'INS') && (SVLEN <= 50000 && SVLEN >= -50000) && FILTER = 'PASS'" \
    ${ver}/${out}.vcf.gz  | \
    bgzip -c > ${ver}/${out}_INDELS.vcf.gz
bcftools index --tbi ${ver}/${out}_INDELS.vcf.gz


conda activate truvari
truvari bench \
    --pick single \
    --pctseq 0.7  \
    --pctsize 0.7 \
    --includebed mosaic_bench.bed \
    --base mosaic_bench.vcf.gz \
    --comp   ${ver}/${out}_INDELS.vcf.gz \
    --output ${ver}/mosaic_bench \
    --reference chr21.fasta.gz
