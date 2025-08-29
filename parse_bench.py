#!/usr/bin/env python
import sys
import pysam


def main(vcf_file: str):
    vcf = pysam.VariantFile(vcf_file)
    out = pysam.VariantFile('-', 'w', header=vcf.header)
    for sv in vcf:
        vaf = sv.info.get("VAF")
        ref, alt = vaf
        if alt > 0.1:
            out.write(sv)
    vcf.close()


if "__main__" == __name__:
    if len(sys.argv) == 2:
        _, vcf_file = sys.argv
        main(vcf_file)
