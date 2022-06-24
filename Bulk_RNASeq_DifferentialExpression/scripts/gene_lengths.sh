#!/bin/bash
#SBATCH --partition=express

/home/<username>/.conda/envs/trinity-env/opt/trinity-2.8.5/util/misc/TPM_weighted_gene_length.py \
  --gene_trans_map ../../reference_data/V47_GxT_Map.txt \
  --trans_lengths transcript_lengths.txt \
  --TPM_matrix salmon.isoform.TMM.matrix > gene_lengths.txt
