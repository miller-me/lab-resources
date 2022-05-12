#!/bin/bash
#SBATCH --nodes=1
#SBATCH --time=8:00:00
#SBATCH --partition=short
#SBATCH --job-name=quant
#SBATCH --mem=10G

# quantification.sh
# This script will prepare a transcriptome index of the V47 axolotl transcriptome assembly.
# It will then quantify reads specified in "samples.txt"

# EDIT this path to point to this script file in YOUR conda environment
/home/<username>/.conda/envs/trinity-env/opt/trinity-2.8.5/util/align_and_estimate_abundance.pl \
  --transcripts ../reference_data/AmexT_v47_dna.fa \
  --seqType fa \
  --samples_file samples.txt \
  --est_method salmon \
  --salmon_idx_type quasi \
  --prep_reference \
  --salmon_add_opts "--validateMappings --recoverOrphans --rangeFactorizationBins 4 --seqBias" \
  --gene_trans_map ../reference_data/V47_GxT_Map.txt
