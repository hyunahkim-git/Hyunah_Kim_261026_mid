library(dada2)
rawpath <- system.file("extdata", package = "dada2")
fnFs <- file.path(rawpath,
                  c("sam1F.fastq.gz", "sam2F.fastq.gz"))
fnRs <- file.path(rawpath,
                  c("sam1R.fastq.gz", "sam2R.fastq.gz"))
sample.names <- c("sam1", "sam2")
plotQualityProfile(fnFs[1:2])
plotQualityProfile(fnRs[1:2])
filtered_forward_reads <- file.path("filtered", paste0(sample.names, "_F_filt.fastq.gz"))
filtered_reverse_reads <- file.path("filtered", paste0(sample.names, "_R_filt.fastq.gz"))
names(filtered_forward_reads) <- sample.names
names(filtered_reverse_reads) <- sample.names
??filterAndTrim
out <- filterAndTrim(fnFs, 
                     filtered_forward_reads, 
                     fnRs,
                     filtered_reverse_reads,
                     truncLen=c(230,160),
                     compress=TRUE,
                     maxEE=c(2,2))
out
error_F <- learnErrors(filtered_forward_reads)
error_R <- learnErrors(filtered_reverse_reads)
plotErrors(error_F, nominalQ=TRUE)
plotErrors(error_R, nominalQ=TRUE)
forward_dada <- dada(filtered_forward_reads, err=error_F)
reverse_dada <- dada(filtered_reverse_reads, err=error_R)
mergers <- mergePairs(forward_dada, 
                      filtered_forward_reads,
                      reverse_dada,
                      filtered_reverse_reads,
                      verbose=TRUE)
??mergePairs
seqtab <- makeSequenceTable(mergers)
dim(seqtab)
table(nchar(getSequences(seqtab)))
seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE, verbose=TRUE)
dim(seqtab.nochim)
sum(seqtab.nochim)/sum(seqtab)
getN <- function(x) sum(getUniques(x))
track <- cbind(out,
               sapply(forward_dada, getN),
               sapply(reverse_dada, getN), 
               sapply(mergers, getN), rowSums(seqtab.nochim))
colnames(track) <- c("input", "filtered", "denoisedF", "denoisedR", "merged", "nonchim")
rownames(track) <- sample.names
head(track)

install.packages("phangorn")
BiocManager::install("DECIPHER")
library(phangorn)
library(DECIPHER)
library(ape)
library(Biostrings)
??phangorn
??DECIPHER
??ape
asv_abundance <- colSums(seqtab.nochim)
asv_abundance <- sort(asv_abundance, decreasing = TRUE)
top5_seqs <- names(asv_abundance)[1:5]
top5_names <- paste0("ASV", 1:5)
top5_table <- data.frame(ASV = top5_names,
                         Total_reads = asv_abundance[1:5],
                         Sequence = top5_seqs,
                         row.names = NULL)
print(top5_table)
??DNAStringSet
seqs <- DNAStringSet(top5_seqs)
names(seqs) <- top5_names
alignment <- AlignSeqs(seqs, anchor = NA)
alignment
phang.align <- phyDat(as(alignment, "matrix"), type = "DNA")
dm <- dist.ml(phang.align)
treeNJ <- NJ(dm)
plot(treeNJ,
     type = "unrooted",
     main = "Neighbor-Joining Tree of Top 5 ASVs")
write.tree(treeNJ, file = "top5_ASV_NJ_tree.newick")
tree_check <- read.tree("top5_ASV_NJ_tree.newick")
tree_check
