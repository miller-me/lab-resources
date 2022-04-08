Getting Started with Differential Expression
================

-   [Overview](#overview)
-   [Setting up](#setting-up)
    -   [Access Discovery](#access-discovery)
    -   [Organize your files](#organize-your-files)
    -   [Transfer your raw data to
        Discovery](#transfer-your-raw-data-to-discovery)
-   [Next steps](#next-steps)

## Overview

When RNA-Seq data is sourced from differing conditions, whether that be
tissues from different areas of the body, collection at different
timepoints, or under treatment of different drug concentrations, a
differential expression analysis allows you to find the genes that are
significantly up- or down-regulated between these conditions. The
results of a differential expression analysis can be a starting point
for something like FISH or overexpression and knockdown experiments for
genes of interest. There are several methods for performing differential
expression analyses, all with unique strategies for dissecting RNA-Seq
data for significant genes; however, the “differential expression”
portion of an analysis is only one piece of a much longer pipeline. The
steps outlined in this repository are intended to guide a differential
expression analysis [starting with the raw data](#setting-up) directly
from the sequencer through to meaningful results files and
visualizations.

## Setting up

#### Access Discovery

Make sure you [have an account on
Discovery](../Intros_to_Coding/Discovery_HPC.md). Using Terminal on Mac
or MobaXTerm on Windows, log in to the Discovery cluster (without the
`$` - this symbol indicates that these commands are to be run in your
command line):

``` bash
$ ssh <username>@login.discovery.neu.edu
```

This will take you to your `home` directory on a login node. You can
check where you are with `pwd`.

Switch over to a compute node:

``` bash
$ srun --pty /bin/bash
```

This tells Discovery to move you to a compute node for (the standard) 4
hours and will output your results to the command line interface (CLI).
If you want more time, add the flag `--time=HH:MM:SS` to request up to
24 hours (`24:00:00`).

#### Organize your files

Your `home` directory is not for storing files or doing any work in.
Move to your `scratch` directory for this:

``` bash
$ cd /scratch/<username>/
```

Now make a directory for your project, with **NO SPACES**. Use
underscores instead:

``` bash
$ mkdir <project-name>
```

You can then `cd` into this directory and `mkdir` some sub-directories
like `raw_data`, `logs`, and `results`. Use `cd` to move into `raw_data`
or your equivalent. Use `pwd` and you should see something like:

``` bash
/scratch/<username>/<project-name>/raw_data
```

#### Transfer your raw data to Discovery

Select and copy the output of `pwd` above. Then, open a new Terminal or
MobaXTerm window. Use `cd` to locally navigate to where your `.fastq`
files are stored. They may be gzip-compressed as `.fastq.gz`.

To transfer data from your local computer, use `scp`:

``` bash
# If your files are zipped, you might need to use *.fastq.gz or similar
# The * is a wildcard indicating that ALL files matching the .fastq ending will be uploaded
$ scp *.fastq <username>@xfer.discovery.neu.edu:/path/to/raw_data/
```

`scp` will begin to copy the data from your computer to your `raw_data`
file in Discovery through a transfer node (denoted with that `xfer`).
This command will be used regularly to move files between the cluster
and your local computer.

This may take a decent amount of time depending on your file sizes and
connectivity speed. Do not close the window running `scp`. If you want
to copy an entire folder recursively, instead of creating the `raw_data`
folder and then copying individual files, make sure you are one
directory *above* the local folder containing your data, then use the
following:

``` bash
$ scp -r <data-directory-name> <username>@xfer.discovery.neu.edu:<desired-location>
```

Once your files have finished uploading, you can check that they are in
the correct location by moving to your intended directory (in Discovery)
using `cd` and then listing its contents with `ls`.

## Next steps

With your data successfully uploaded to the cluster, and with your files
organized, you’re ready to begin! The first step is [quality checking
your reads and trimming away low-quality
areas](Step_1_QualityTrimming.md).
