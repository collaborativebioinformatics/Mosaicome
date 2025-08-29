#!/usr/bin/env python
import sys
import pysam


def main(vcf_file: str, info_key):
    vcf = pysam.VariantFile(vcf_file)
    for sv in vcf:
        infos = sv.info.get(info_key)
        print(infos)
    vcf.close()


if "__main__" == __name__:
    if len(sys.argv) == 3:
        _, vcf_file, get_info = sys.argv
        main(vcf_file, get_info)
