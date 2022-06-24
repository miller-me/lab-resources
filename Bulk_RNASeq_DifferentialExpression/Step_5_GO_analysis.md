Step 5: Gene Ontology Analysis
================

-   [Overview](#overview)
-   [Set up](#set-up)
    -   [Install the goseq package](#install-the-goseq-package)
    -   [Supporting files](#supporting-files)
        -   [Making `gene_lengths.txt`](#making-gene_lengthstxt)
    -   [Run GO analysis](#run-go-analysis)
        -   [Parameter options](#parameter-options)
    -   [Outputs](#outputs)
        -   [Troubleshooting](#troubleshooting)
            -   [`--order_columns_by_samples_file`](#--order_columns_by_samples_file)
            -   [Heatmap is unreadable](#heatmap-is-unreadable)
        -   [Plotting your results](#plotting-your-results)
-   [Next steps](#next-steps)

## Overview

Gene ontology (GO) is the functional annotation of genes. GO analysis is
important because a gene name does not itself indicate function, and
because, from a list of differentially expressed genes, you want to know
what kinds of processes those genes are involved in. One gene can have
many different GO terms associated with it, and each GO term similarly
has many different genes associated with it. GO terms have a range of
specificity, and are grouped into three major categories: molecular
function, cellular component, and biological process. Examples of each
are, respectively: “transmembrane signaling receptor binding”, “external
side of plasma membrane”, and “positive regulation of cardiac muscle
cell proliferation”.

## Set up

Move to a compute node if you aren’t already on one:

``` bash
$ srun --pty /bin/bash
```

Then load `anaconda` and `R`:

``` bash
$ module load anaconda3/3.7
```

``` bash
$ module load R/4.0.3
```

Activate your `trinity-env`:

``` bash
$ source activate trinity-env
```

### Install the goseq package

As of writing this, there are a few workarounds to installing `goseq`
due to the Discovery cluster’s support of some outdated software. If you
were to try to install `goseq` using the normal `BiocManager::install()`
function in `R`, you would get an error that one dependency in
particular, `rtracklayer`, could not be installed; this is a result of
Discovery’s outdated software. Luckily your `trinity-env` contains a new
version of this software that you can use instead. In order to do this,
you need to create some new *environment variables*: `PKG_CONFIG_PATH`
and `OPENSSL_LIBS`.

First, check that they don’t already exist:

``` bash
$ echo $PKG_CONFIG_PATH
```

``` bash
$ echo $OPENSSL_LIBS
```

There should be blank space returned. To find the path to these
variables, search in your `trinity-env` library:

``` bash
$ cd ~/.conda/envs/trinity-env/lib
```

``` bash
$ ls 
```

Scroll through the output. You should see two things: a directory called
`pkgconfig`, and an *executable* called `libssl.so.1.1`. Now to set your
variables, editing where appropriate:

``` bash
$ PKG_CONFIG_PATH=/home/<username>/.conda/envs/trinity-env/lib/pkgconfig; export PKG_CONFIG_PATH 
```

``` bash
$ OPENSSL_LIBS=/home/<username>/.conda/envs/trinity-env/lib/libssl.so.1.1; export OPENSSL_LIBS
```

Now repeat your `echo` from earlier:

``` bash
$ echo $PKG_CONFIG_PATH
```

``` bash
$ echo $OPENSSL_LIBS
```

The respective paths you just defined should now be the outputs. Now
open the `R` interface:

``` bash
$ R
```

There’s a little weirdness with `R` sometimes, so make sure at the top
it says you are in version `4.0.3`. If you are not, `module unload R`
then `module load R/4.0.3`. In the interface, enter:

``` r
BiocManager::install("goseq")
```

This will take a few minutes as all of the installation steps are run.
Then quit `R` with `q()`. If you run into more errors, or do not have
the `pkgconfig` directory or `libssl.so.1.1` executable, please contact
Melissa.

### Supporting files

You will be executing GO analysis in the directory output by [your
differential expression analysis](Step_4_DifferentialExpression.md),
because the script needs access to a few of these files, so `cd` into
it. You will also need some additional files:

1.  Your `salmon.gene.TMM.EXPR.matrix` output by
    [`getMatrices.sh`](Step_2_AbundanceQuant.md/#preparing-for-next-steps).
2.  Your `samples_ptr.txt` file used in [quality
    control](Step_3_ReplicateQC.md/#set-up).
3.  A file assigning GO annotations to each gene. This
    `go_annotations.txt` file can be found [in the supporting_files
    directory](./supporting_files/go_annotations.txt). You can download
    this and `scp` to Discovery.
4.  A `gene_lengths.txt` file indicating each gene’s length, important
    for normalization and removing gene length bias.

#### Making `gene_lengths.txt`

In order to make your `gene_lengths.txt`, you need a few *other* files
first:

1.  The `V47_GxT_Map.txt` in the [supporting_files
    directory](./supporting_files/V47_GxT_Map.txt).
2.  Your `salmon.isoform.TMM.EXPR.matrix` output by
    [`getMatrices.sh`](Step_2_AbundanceQuant.md/#preparing-for-next-steps).
3.  A `transcript_lengths.txt` file.

To make the `transcript_lengths.txt` file, you can use a script included
in the `Trinity` package directly in your command line. All you need is
the `AmexT_v47_dna.fa` transcriptome. On a compute node, with
`anaconda3/3.7` loaded and your `trinity-env` activated, run:

``` bash
$ /home/<username>/.conda/envs/trinity-env/opt/trinity-2.8.5/util/misc/fasta_seq_len.pl ../../reference_data/AmexT_v47_dna.fa > transcript_lengths.txt
```

Make sure to edit the username! `../../reference_data/` indicates the
path moving up two directories from the current DESeq2 output directory
and back down to `reference_data` where the transcriptome is, so edit
your path to the transcriptome accordingly.

This will take a minute. Next you can create the `gene_lengths.txt`
file. You can use this script directly in your command line, or there is
[a copy in the `scripts` directory](./scripts/gene_lengths.sh):

``` bash
$ /home/<username>/.conda/envs/trinity-env/opt/trinity-2.8.5/util/misc/TPM_weighted_gene_length.py \
  --gene_trans_map ../../reference_data/V47_GxT_Map.txt \
  --trans_lengths transcript_lengths.txt \
  --TPM_matrix salmon.isoform.TMM.EXPR.matrix > gene_lengths.txt
```

Again, edit the username and path to the `V47_GxT_Map.txt`,
`transcript_lengths.txt`, and `salmon.isoform.TMM.EXPR.matrix`
accordingly.

### Run GO analysis

You’re ready to run the GO analysis! Make sure you are within the
directory output by DESeq2, as `goseq` needs several of these files for
its analysis. With a compute node activated, `anaconda` and `R` modules
loaded, and `trinity-env` activated, create your `goseq.sh`:

``` bash
$ vim goseq.sh
```

Enter the following (a copy is also available [in the `scripts`
directory](./scripts/goseq.sh)):

``` bash
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
```

Give the script execution permission:

``` bash
$ chmod u+x goseq.sh
```

And run with `sbatch`:

``` bash
$ sbatch goseq.sh
```

##### Parameter options

Within `goseq.sh` there are a few parameters which are left up to you to
edit as is best for your analysis.

1.  `-P` indicates the p-value cutoff for if a gene is considered
    differentially expressed. The default is `0.001`.
2.  `-C` indicates the log fold change cutoff. The default is `2`.
3.  `--samples` is the sample name and replicates map you’ve been using.
4.  `--max_DE_genes_per_comparison` indicates the maximum number of
    differentially expressed genes that will be picked out of each
    pairwise comparison for plotting. Increase or decrease this number
    depending on [how your output heatmaps](#outputs) look.
5.  `--order_columns_by_samples_file` will do exactly that in your
    heatmap, rather than the default ordering by sample similarity.
6.  `--examine_GO_enrichment` with its flags `--GO_annots` and
    `--gene_lengths` are what is doing the GO analysis. Without these
    flags, you will not get [lists of enriched and depleted GO
    terms](#outputs), but you will still get the differentially
    expressed genes heatmap.

An additional flag is `--output`: this sets the prefix for all of the
output files. The default is
`diffExpr.P(value set by -P)_C(value set by -C)`, e.g.,
`diffExpr.P0.001.C2`.

### Outputs

1.  `__runGOseq.R`, as the name implies, is the Rscript file written to
    perform the GOseq analysis. This file is re-written every time you
    run the `goseq.sh` script, so be careful because you won’t
    necessarily be able to re-use it later on.
2.  `{prefix}.matrix` is a counts matrix of the genes identified as
    differentially expressed. This matrix is read by `{prefix}.matrix.R`
    to create the heatmap. This will only be overwritten if you use the
    same `{prefix}` in a new `goseq.sh` run.
3.  `{prefix}.matrix.R` is the Rscript that generates the heatmap and
    writes out `{prefix}.matrix.log2.centered.dat` and
    `{prefix}.matrix.log2.centered.sample_cor.dat`. Again, this and the
    following files will only be overwritten if you use the same
    `{prefix}` on a new `goseq.sh` run.
4.  `{prefix}.matrix.log2.centered.dat` is a matrix of the log2 fold
    changes for the differentially expressed genes between samples,
    plotted in the heatmap.
5.  `{prefix}.matrix.log2.centered.sample_cor.dat` is a matrix of the
    similarities between each sample, used to generate the dendrogram on
    your heatmap.
6.  `{prefix}.matrix.log2.centered.sample_cor_matrix.pdf` is the PDF
    containing the heatmap. To view this file, you will need to `scp` it
    to your local computer and open it there.
7.  `{prefix}.matrix.RData` stores all of the data from the
    `{prefix}.matrix.R` steps so that it can be easily re-accessed and
    used. If you are using the same `{prefix}` but altering your
    parameters somehow, I recommend deleting this file before running
    `goseq.sh`.

#### Troubleshooting

The GOseq section is a little finicky, so there are some issues you
might have to fix, especially for making a paper figure. I’m going to
cover some I’ve run into below, but if there are new problems you
encounter feel free to reach out.

##### `--order_columns_by_samples_file`

When you include this flag, you might receive an error that “the object
`hc_samples` can not be found”. This is because the [`{prefix}.matrix.R`
file that is created](#outputs) doesn’t actually ever create this object
(a small bug that the `trinity` creators will hopefully fix in later
versions). It is simple to overcome this issue, however, by defining
`hc_samples` yourself.

First, delete the `{prefix}.matrix.RData` file so it’s not reused. Then
use `vim` to open the `{prefix}.matrix.R` file:

``` bash
$ vim {prefix}.matrix.R
```

In the `vim` interface, type `:set number` and hit `enter` to add line
numbers. Then hit `i` to enter `insert` mode. Add a new line below line
78 where `sample_dist` is defined. In this line, enter the following:

``` r
hc_samples = hclust(sample_dist, method='complete')
```

Hit `escape` to exit `insert` mode. Then type `:wq` and hit `enter` to
save the file and quit `vim`. With the `R/4.0.3` module loaded and your
`trinity-env` activated:

``` bash
$ Rscript {prefix}.matrix.R
```

This should successfully rerun the script that creates the heatmap. If
you receive an error about the `hclust` method, try changing `complete`
to `euclidean`.

##### Heatmap is unreadable

If you `scp` your `{prefix}.matrix.log2.centered.sample_cor_matrix.pdf`
to your local computer, only to open it and realize that the font on the
genes is too small to read, you’ll need to lower the
`--max_DE_genes_per_comparison` number. Alternatively, increase this
number if you feel there aren’t enough genes depicted in your heatmap.

#### Plotting your results

To plot your GO results, I’ve included a [`plot_GO_results.R` script in
the scripts directory](./scripts/plot_GO_results.R) that you can run
locally if you have R or RStudio installed. Otherwise, you can `scp` it
to Discovery and run there. This script utilizes [the `ggplot2`
package](https://ggplot2.tidyverse.org) which you will need to install,
potentially along with some others. There are further directions
commented within the script that I will not walk through here.

## Next steps

Congratulations! Now your work is more or less done (aside from all the
FISH and whatnot that you’ll now have to follow-up your results with).
There is also [the `Trinotate`
package](https://github.com/Trinotate/Trinotate.github.io/wiki) to
generate a full annotation report to visualize all kinds of expression
charts, but I will not be covering that here. RNA-Seq analysis is an
important tool to understand and know how to use, so once again nice
work on seeing your project through! :) I hope you’ve learned a lot
about the process and bioinformatics work in general. If you have
questions, comments, or concerns about something you’ve encountered
along the way, please reach out!
