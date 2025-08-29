#!/bin/bash

ver="v3"
out="mosaic_snf2_calls_vaf1_100"

truvari bench \
    --pick single \
    --pctseq 0.7  \
    --pctsize 0.7 \
    --includebed mosaic_bench.bed \
    --base mosaic_bench.vcf.gz \
    --comp   ${ver}/${out}_INDELS.vcf.gz \
    --output ${ver}/mosaic_bench \
    --reference chr21.fasta.gz
