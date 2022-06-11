#!/bin/bash
#SBATCH --partition=short
#SBATCH --cpus-per-task=16
#SBATCH --job-name=FASTQC
#SBATCH --nodes=1

# You can delete these but I like to leave them in 
# just in case you forget to load the modules
module load oracle_java
module load fastqc

# Change the ".fastq.gz" extension if needed
# Change the path to the results folder as needed
# * is a wildcard representing ALL characters, so ALL files will be processed
fastqc /path/to/paired/*.fastq.gz -t 16 -o ../results/
