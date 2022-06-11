#!/bin/bash
#SBATCH --time=8:00:00
#SBATCH --partition=short
#SBATCH --cpus-per-task=16
#SBATCH --job-name=Trimming
#SBATCH --nodes=1

# trimmomatic.sh
# This script uses Trimmomatic to quality trim raw reads in the working directory

# You can delete these lines if you've already loaded the modules
# I like to leave them in just in case you forget to though
module load oracle_java
module load trimmomatic

# Initializing variable for path to fastq files
# Replace with the absolute path to your untrimmed files
raw_file_path="/path/to/untrimmed_files/"

# Initializing variable for the suffixes of the raw reads
# If your suffixes are different, edit this to match
left_suffix="_R1_001.fastq.gz"
right_suffix="_R2_001.fastq.gz"

# Initializing output directories
# Change the paths to where you want your output files to go
paired_out="/path/to/paired/output/"
unpaired_out="/path/to/unpaired/output/"

# Creating output directories
mkdir -p $paired_out
mkdir -p $unpaired_out

# Creating trimming function to perform on all reads
function trim_reads {
    # Looping over all left reads in the raw files. "*" is a wildcard, do NOT remove
    for left_read_file in $raw_file_path*$left_suffix
    do
        # Removing the path from the file name and assigning to a new variable
        no_path="${left_read_file/$raw_file_path/}"
        # Removing suffix from the file name and assigning to new variable
        sample_name="${no_path/$left_suffix/}"
        # This line calls the actual Trimmomatic module
        # Parameters are described in Step_1_QualityTrimming.md on lab GitHub page
        # DO NOT DELETE any of the "\"
        java -jar /shared/centos7/trimmomatic/0.39/trimmomatic-0.39.jar PE \
        -threads 16 -phred33 \
        $raw_file_path$sample_name$left_suffix \
        $raw_file_path$sample_name$right_suffix \
        $paired_out$sample_name$left_suffix \
        $unpaired_out$sample_name$left_suffix \
        $paired_out$sample_name$right_suffix \
        $unpaired_out$sample_name$right_suffix \
        HEADCROP:0 \
        ILLUMINACLIP:/shared/centos7/trimmomatic/0.39/adapters/TruSeq3-PE.fa:2:30:10 \
        LEADING:3 TRAILING:25 SLIDINGWINDOW:4:30 MINLEN:36
    done
}
trim_reads
# ^ we need to call the function with "trim_reads" here, otherwise nothing will happen
