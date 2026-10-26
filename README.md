# IBS7048 Metagenomics Midterm (2026)

This repository contains Bash and R scripts for the IBS7048 metagenomics midterm assignment. The scripts cover FASTQ file organization, sequencing-platform calculations, amplicon processing, host-read depletion, and interpretation of microbiome-associated statistics.

## Scripts

| File | Description |
| --- | --- |
| `midterm_1.sh` | Creates 40 example FASTQ files, sorts them by treatment condition and read direction using Bash, and counts the files in each folder. |
| `midterm_2.R` | Performs the same FASTQ sorting in R and compares the R and Bash folder contents by relative filename. |
| `midterm_3.R` | Calculates the number of samples and expected microbial sequence yield for three sequencing platforms under a $600 example budget. |
| `midterm_4.R` | Runs a DADA2 paired-end amplicon workflow, tracks reads, selects the five most abundant ASVs, and constructs a Neighbor-Joining tree. |
| `midterm_5.R` | Calculates microbial and non-`Taxon_X` reads before and after treatment; includes installation/help commands for `decontam`. |
| `midterm_6.R` | Calculates changes in odds ratios, CASI scores, and estimated probabilities for a change in microbiome score. |

## Requirements

- Bash (for `midterm_1.sh`)
- R (RStudio recommended for examining plots and help pages)
- R packages: `tidyverse`, `dada2`, `phangorn`, `DECIPHER`, `ape`, `Biostrings`, `decontam`

Install the required R packages when needed:

```r
install.packages(c("tidyverse", "phangorn", "ape", "BiocManager"))
BiocManager::install(c("dada2", "DECIPHER", "Biostrings", "decontam"))
```

## How to run

Run the commands below from the repository directory (the directory containing `midterm_1.sh`).

### 1. Create and sort example FASTQ files (Bash)

```bash
bash midterm_1.sh
```

This creates an `IBS7048_2026/` directory containing the `raw/` and `sorted_bash/` folders. The script generates 40 **example** FASTQ files (5 samples × 2 conditions × 2 replicates × 2 read directions). It prints the number of files in each sorted group:

```text
Control/R1: 10
Control/R2: 10
Treated/R1: 10
Treated/R2: 10
```

### 2. Sort FASTQ files in R and compare results

In `midterm_2.R`, replace the computer-specific paths with paths relative to the working directory:

```r
mid_path <- file.path(getwd(), "raw")
base_path <- getwd()
```

The initial `list.files("/Users/...")` line is also computer-specific and can be removed or changed to `list.files(getwd())`.

Then run the R script **inside** the newly created `IBS7048_2026/` folder:

```bash
cd IBS7048_2026
Rscript ../midterm_2.R
```

The script creates `sorted_R/`, prints the file count for each group, and uses `identical(bash_files, r_files)` to compare the sorted **relative filenames**. The expected comparison result is `TRUE` when the two directory structures contain the same relative filenames. This is not a comparison of FASTQ contents.

### 3. Run the remaining R scripts

Return to the repository directory:

```bash
cd ..
```

For `midterm_3.R`, change `view(sequencing)` to `print(sequencing)` (or use `View(sequencing)` interactively in RStudio), because R is case-sensitive and `view()` is not the standard base-R viewer.

For `midterm_4.R`, create the output folder before filtering:

```r
dir.create("filtered", showWarnings = FALSE)
```

The `??` lines in `midterm_4.R` and `midterm_5.R` are interactive help searches and can be commented out when running non-interactively. Package installation commands inside these scripts are needed only for initial setup.

After those adjustments, run:

```bash
Rscript midterm_3.R
Rscript midterm_4.R
Rscript midterm_5.R
Rscript midterm_6.R
```

`midterm_4.R` uses the paired-end example FASTQ files included in the `dada2` package, with `truncLen = c(230, 160)` and `maxEE = c(2, 2)`. It writes a Neighbor-Joining tree to `top5_ASV_NJ_tree.newick` in the current working directory.

## Output structure

After running the FASTQ organization scripts, the main generated files are arranged as follows:

```text
IBS7048_2026/
├── raw/                  # 40 example FASTQ files
├── sorted_bash/
│   ├── Control/
│   │   ├── R1/
│   │   └── R2/
│   └── Treated/
│       ├── R1/
│       └── R2/
└── sorted_R/
    ├── Control/
    │   ├── R1/
    │   └── R2/
    └── Treated/
        ├── R1/
        └── R2/
```

The DADA2 workflow also generates filtered read files in `filtered/` and the Newick tree file `top5_ASV_NJ_tree.newick`.

## Notes

- The FASTQ files from `midterm_1.sh` are synthetic examples, not experimental sequencing data.
- The sequencing-platform parameters in `midterm_3.R` and the numerical inputs in `midterm_5.R` and `midterm_6.R` are values defined in the scripts for the assignment.
- `midterm_5.R` does **not** run `isContaminant()`; it only includes `decontam` installation and help lookup commands.
- To inspect quality-profile and phylogenetic plots from `midterm_4.R`, running the script interactively in RStudio is recommended.
