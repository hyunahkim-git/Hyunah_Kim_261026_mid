#!/bin/bash

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
