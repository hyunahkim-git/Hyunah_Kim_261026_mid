#!/bin/bash

mkdir -p IBS7048_2026/raw
cd IBS7048_2026

for sample in S01 S02 S03 S04 S05
do
    for condition in Treated Control
    do
        for rep in 1 2
        do
            for read in R1 R2
            do
                file="${sample}_${condition}_${rep}_${read}.fastq"
                printf '@%s\nACGTACGTACGT\n+\nFFFFFFFFFFFF\n' \
                    "$file" > "raw/$file"
            done
        done
    done
done

mkdir -p sorted_bash

for file in raw/*.fastq
do
    filename=$(basename "$file")

    condition=$(echo "$filename" | cut -d'_' -f2)
    read=$(echo "$filename" | cut -d'_' -f4 | cut -d'.' -f1)

    mkdir -p "sorted_bash/$condition/$read"

    cp "$file" "sorted_bash/$condition/$read/"
done

for condition in Control Treated
do
    for read in R1 R2
    do
        echo "$condition/$read:"
        find "sorted_bash/$condition/$read" -type f -name "*.fastq" | wc -l
    done
done
