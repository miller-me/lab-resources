#!/bin/bash
#SBATCH --partition=express

# quality_check.sh
# This script uses Trinity's PtR script to generate sample replicate and cross-sample QC plots.
# Edit the username to your own

# This generates the sample replicate comparisons for each condition
/home/<username>/.conda/envs/trinity-env/opt/trinity-2.8.5/Analysis/DifferentialExpression/PtR \
  --matrix salmon.isoform.counts.matrix \
  --samples samples_ptr.txt \
  --log2 --CPM \
  --min_rowSums 10 \
  --compare_replicates

# This generates the sample correlation heatmap
/home/<username>/.conda/envs/trinity-env/opt/trinity-2.8.5/Analysis/DifferentialExpression/PtR \
  --matrix salmon.isoform.counts.matrix \
  --samples samples_ptr.txt \
  --log2 --CPM \
  --min_rowSums 10 \
  --sample_cor_matrix

# This generates a principal component analysis for the top 3 principal components
/home/<username>/.conda/envs/trinity-env/opt/trinity-2.8.5/Analysis/DifferentialExpression/PtR \
  --matrix salamon.isoform.counts.matrix \
  --samples samples_ptr.txt \
  --log2 --CPM \
  --min_rowSums 10 \
  --center_rows \
  --prin_comp 3
