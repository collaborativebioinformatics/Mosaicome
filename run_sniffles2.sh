#!/bin/bash

snf2_mod="/home/lpaz/Documents/baylor/hackathon/Sniffles/src/sniffles2_mod"

. /home/lpaz/bin/miniconda3_23_1_py10/etc/profile.d/conda.sh

contig=$1

ver="v1"
out="mosaic_snf2_calls_vaf1_100"
conda activate snf2dev

if [[ ! -d "b3/${contig}/${ver}/" ]];
then
    mkdir -p b3/${contig}/${ver}/
fi

if [[ ! -f "b3/${contig}/${ver}/${out}.vcf.gz" ]]
then
    ${snf2_mod} \
        --input mosaic_data_${contig}.bam \
        --vcf   b3/${contig}/${ver}/${out}.vcf.gz \
        --snf   b3/${contig}/${ver}/${out}.snf \
        --threads 1 \
        --contig ${contig} \
        --reference ref.fasta.gz \
        --mapq 18 \
        --minsvlen 50 \
        --minsupport 3 \
        --mosaic-af-min 0.01 \
        --mosaic-include-germline \
        --output-rnames \
        --no-qc \
        --sample-id mosaic
fi

bcftools view \
    --include "(SVTYPE = 'DEL' || SVTYPE = 'INS') && (SVLEN <= 50000 && SVLEN >= -50000)" \
    b3/${contig}/${ver}/${out}.vcf.gz  | \
    bgzip -c > b3/${contig}/${ver}/${out}_INDELS_noqc.vcf.gz
bcftools index --tbi b3/${contig}/${ver}/${out}_INDELS_noqc.vcf.gz

bcftools view \
    --include "(SVTYPE = 'DEL' || SVTYPE = 'INS') && (SVLEN <= 50000 && SVLEN >= -50000) && FILTER = 'PASS'" \
    b3/${contig}/${ver}/${out}.vcf.gz  | \
    bgzip -c > b3/${contig}/${ver}/${out}_INDELS.vcf.gz
bcftools index --tbi b3/${contig}/${ver}/${out}_INDELS.vcf.gz


conda activate truvari
truvari bench \
    --pick single \
    --pctseq 0.7  \
    --pctsize 0.7 \
    --includebed mosaic_bench_${contig}.bed \
    --base mosaic_bench_${contig}.vcf.gz \
    --comp   b3/${contig}/${ver}/${out}_INDELS.vcf.gz \
    --output b3/${contig}/${ver}/bench \
    --reference ref.fasta.gz
