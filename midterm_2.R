getwd()
list.files("/Users/hyunah/Desktop/M.S./first/Metagenomics/261023_mid/IBS7048_2026")
mid_path = "/Users/hyunah/Desktop/M.S./first/Metagenomics/261023_mid/IBS7048_2026/raw"
base_path = "/Users/hyunah/Desktop/M.S./first/Metagenomics/261023_mid/IBS7048_2026"
list.files(mid_path, pattern = "\\.fastq")
library(tidyverse)
files <- list.files(mid_path, pattern="\\.fastq", full.names = TRUE) %>% sort()
conditions <- files %>% 
  basename() %>% 
  str_split_fixed("_", 4) %>% 
  .[,2]
reads <- files %>% 
  basename() %>% 
  str_split_fixed("_", 4) %>% 
  .[,4] %>%
  str_split_fixed("\\.", 2) %>%
  .[,1]
for (i in seq_along(files)) {
  
  R <- file.path(dirname(mid_path),
                 "sorted_R",
                  conditions[i],
                  reads[i])
  
  dir.create(R,
             recursive = TRUE,
             showWarnings = FALSE)
  
  file.copy(files[i], R, overwrite = TRUE)
}
for (condition in c("Control", "Treated")) {
  for (read in c("R1", "R2")) {
    
    path <- file.path(base_path, "sorted_R", condition, read)
    
    cat(condition, "/", read, ":\n", sep = "")
    cat(length(list.files(path, pattern = "\\.fastq")), "\n")
    
  }
}
bash_files <- sort(list.files("sorted_bash", recursive = TRUE))

r_files <- sort(list.files("sorted_R", recursive = TRUE))

identical(bash_files, r_files)
