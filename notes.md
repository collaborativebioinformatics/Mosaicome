|#test | FP  | FN | Precision | Recall | F1 | Notes |
|------|-----|----|-----------|--------|----|--------|
| Best diff (7-1) | 40 | -75 | -6.62% | 12.52% | 7.21% |  |
| 1 | 30 | 297 | 90.96% | 50.42% | 64.88% | Default |
| 2 | 46 | 259 | 88.08% | 56.76% | 69.04% | --mosaic-af-min 0.01 (USER) |
| 3 | 70 | 224 | 84.27% | 62.60% | 71.84% | --mosaic-af-min 0.01 --minsupport 3 (USER) + mosaic_min_reads = 2 for DEL and INS (INTERNAL) |
| 4 | 70 | 223 | 84.30% | 62.77% | 71.96% | --mosaic-af-min 0.01 --minsupport 3 (USER) + mosaic_min_reads = 2 for DEL and INS (INTERNAL) + minsvlen FILTER deactivated if SUPPORT >= 10 (INTERNAL) |
| 5 | 34 | 314 | 89.34% | 47.58% | 62.09% | Default + minimap2 lr:hq (instead of map-ont) with all reads from original BAM file |
| 6 | 23 | 326 | 92.23% | 45.58% | 61.01% | Default + minimap2 lr:hq (instead of map-ont) with all reads from original BAM file, BUT only with reads with Q>20, 160134 reads less than half of tatal reads |
| 7 | 70 | 222 | 84.34% | 62.94% | 72.08% | --mosaic-af-min 0.01 --minsupport 3 --mapq 18 (USER) + mosaic_min_reads = 2 for DEL and INS (INTERNAL) + minsvlen FILTER deactivated if SUPPORT >= 10 (INTERNAL)" |
| 8 | 34 | 320 | 89.13% | 46.78% | 61.18% | Default + winnowmap |


FP to improve:
	better clustering  +++
	
	low support -> stricter mapq? -> only precise -> SVDEV len/pos stricter
	
	check splits better
	
	2 alleles?
	
	aligment error/repetitive sequnce?
	improve bench?
