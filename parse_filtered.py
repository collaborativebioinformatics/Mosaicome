#!/usr/bin/env python
import sys


def main():
    info_base_dict = {}
    info_comp_dict = {}
    for line in sys.stdin:
        contig, pos_comp, svid_comp, filter_comp, info_comp, gt_comp, \
        pos_base, info_base, _, _, _, _, _, _, _ = line.rstrip("\n").split("\t")
        for info in info_base.split(";"):
            if "SVLEN" in info:
                key, val = info.split("=")
                info_base_dict[key] = val
            elif "SVTYPE" in info:
                key, val = info.split("=")
                info_base_dict[key] = val
        for info in info_comp.split(";"):
            if "SVLEN" in info:
                key, val = info.split("=")
                info_comp_dict[key] = val
            elif "SVTYPE" in info:
                key, val = info.split("=")
                info_comp_dict[key] = val
        if info_base_dict["SVTYPE"] == info_comp_dict["SVTYPE"]:
            if abs(abs(int(info_base_dict["SVLEN"])) - abs(int(info_comp_dict["SVLEN"]))) <= 1000:
                print(line, end="")



if "__main__" == __name__:
    main()