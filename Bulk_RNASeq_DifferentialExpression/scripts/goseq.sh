#!/bin/bash
#SBATCH --partition=express

# Edit the path to your trinity-env
/home/<username>/.conda/envs/trinity-env/opt/trinity-2.8.5/Analysis/DifferentialExpression/analyze_diff_expr.pl \
  --matrix salmon.gene.TMM.EXPR.matrix \
  -P 0.001 \
  -C 2 \
  --samples samples_ptr.txt \
  --max_DE_genes_per_comparison 150 \
  --order_columns_by_samples_file \
  --examine_GO_enrichment \
  --GO_annots go_annotations.txt \
  --gene_lengths gene_lengths.txt
