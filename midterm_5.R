#5c.
condition <- c("Untreated", "Treated")
total_reads <- c(20000000, 20000000)
host_fraction <- c(0.99, 0.90)
taxon_X_fraction <- c(0.10, 0.91)
rawdf <- data.frame(condition,
                    total_reads,
                    host_fraction,
                    taxon_X_fraction)
# Microbial reads
rawdf$microbial_reads <- rawdf$total_reads * (1 - rawdf$host_fraction)

# Reads excluding Taxon_X
rawdf$useful_reads <- rawdf$microbial_reads * (1 - rawdf$taxon_X_fraction)

# Fold changes
microbial_fold <- rawdf$microbial_reads[2] / rawdf$microbial_reads[1]

useful_fold <- rawdf$useful_reads[2] / rawdf$useful_reads[1]

print(rawdf)
print(microbial_fold)
print(useful_fold)


#5d.
BiocManager::install("decontam")
??decontam
??isContaminant





