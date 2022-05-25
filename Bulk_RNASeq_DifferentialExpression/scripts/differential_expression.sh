#!/bin/bash
#SBATCH --partition=express
#SBATCH --time=00:20:00

# Edit path
/home/<username>/.conda/envs/trinity-env/opt/trinity-2.8.5/Analysis/DifferentialExpression/run_DE_analysis.pl \
  --matrix salmon.gene.counts.matrix \
  --method DESeq2 \
  --samples_file samples_ptr.txt
