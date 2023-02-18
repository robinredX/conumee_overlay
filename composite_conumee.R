.cumsum0 <- function(x, left = TRUE, right = FALSE, n = NULL) {
    xx <- c(0, cumsum(as.numeric(x)))
    if (!left) 
        xx <- xx[-1]
    if (!right) 
        xx <- head(xx, -1)
    names(xx) <- n
    xx
}

composite_cnv <- function(sample_ids, ctrl_ids, anno, minfi.data, savename,
                         ylim=c(-1.25, 1.25), cols=c("red", "red", "lightgrey", "green", "green"), 
                          chr="all", chrX=TRUE, chrY=TRUE, centromere=TRUE, main="Composite CNV plot"){
        for (sample in sample_ids){
            print(paste("processing sample", sample))
            x <- CNV.fit(minfi.data[sample], minfi.data[ctrls], anno)
            x <- CNV.bin(x)
            x <- CNV.detail(x)
            x <- CNV.segment(x)

            bin.ratio <- x@bin$ratio - x@bin$shift #  Adjust for shift, different per sample
            detail.ratio <- x@detail$ratio - x@bin$shift

            bin.ratio[bin.ratio < ylim[1]] <- ylim[1] # Clip values 
            bin.ratio[bin.ratio > ylim[2]] <- ylim[2]

            if (sample==sample_ids[1]){
                png(savename, width=2000, height=800, units="px", res=100)

                if (is.null(main)) 
                main <- x@name
                if (chr[1] == "all") {
                    chr <- x@anno@genome$chr
                } else {
                    chr <- intersect(chr, x@anno@genome$chr)
                }

                

                plot(NA, xlim = c(0, sum(as.numeric(x@anno@genome[chr, "size"])) - 
                0), ylim = ylim, xaxs = "i", xaxt = "n", yaxt = "n", xlab = NA, 
                ylab = NA, main = main)

                chr.cumsum0 <- .cumsum0(x@anno@genome[chr, "size"], n = chr)

                if (!chrX & is.element("chrX", names(chr.cumsum0))) 
                        chr.cumsum0["chrX"] <- NA
                if (!chrY & is.element("chrY", names(chr.cumsum0))) 
                        chr.cumsum0["chrY"] <- NA

                abline(v = .cumsum0(x@anno@genome[chr, "size"], right = TRUE), 
                        col = "grey")

                if (centromere) {
                    abline(v = .cumsum0(x@anno@genome[chr, "size"]) + x@anno@genome[chr, 
                        "pq"], col = "grey", lty = 2) 
                }

                axis(1, at = .cumsum0(x@anno@genome[chr, "size"]) + x@anno@genome[chr, 
                    "size"]/2, labels = x@anno@genome[chr, "chr"], las = 2)
                if (all(ylim == c(-1.25, 1.25))) {
                    axis(2, at = round(seq(-1.2, 1.2, 0.4), 1), las = 2)
                } else {
                    axis(2, las = 2)
                }
            }
            bin.ratio.cols <- apply(colorRamp(cols)((bin.ratio + max(abs(ylim)))/(2 * 
                    max(abs(ylim)))), 1, function(x) rgb(x[1], x[2], x[3], maxColorValue = 255)) # Color mapping
            lines(chr.cumsum0[as.vector(seqnames(x@anno@bins))] + values(x@anno@bins)$midpoint, 
                bin.ratio, type = "p", pch = 16, cex = 0.4, col = bin.ratio.cols) # Add points for the current sample
    }
    dev.off()
    }
