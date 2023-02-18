

[Conumee](https://bioconductor.org/packages/release/bioc/html/conumee.html) [1] generates a single copy number variation plot per sample. This is helper function that overlays multiple CNV plots. This repository contains a small R helper function that overlays multiple CNV plots generated from conumee package.

To use you need the following:

```
source("conumee_overlay/composite_conumee.R")
composite_cnv(sample_ids, ctrl_ids, anno, minfi.data, savename, ylim, cols, chr, chrX, chrY, centromere, main)
```

## Notes:

- `sample_ids` are the sample names for which you want to generate CNV plot, and ctrl_ids are the control samples in minfi.data (minfi.data is produced from 
conumee using CNV.load()

- `anno` is annotation file and has same definition as in Conumee.

- `savename` is the path to an image file where you want to save the output

- `ylim, cols, chr, chrX, chrY, centromere` have same definitions as in CNV.genomeplot(). `main` refers to the title the plot. By default, it is "Composite CNV plot". Default values of other arguments is identical to the default values in CNV.genomeplot(). 

[1] Hovestadt V, Zapatka M. conumee: Enhanced copy-number variation analysis using Illumina DNA methylation arrays. R package version 1.9.0, http://bioconductor.org/packages/conumee/. 
