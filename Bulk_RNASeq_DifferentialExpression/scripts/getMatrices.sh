#!/bin/bash
#SBATCH --partition=express

# getMatrices.sh
# This script generates combined counts matrices and TMM-normalized counts matrices on quant_files.list files.

/path/to/your/trinity-env/opt/trinity-2.8.5/util/abundance_estimates_to_matrix.pl \
  --est_method salmon \
  --quant_files quant_files.list \
  --name_sample_by_basedir \
  --gene_trans_map ../reference_data/V47_GxT_Map.txt
