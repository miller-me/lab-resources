Getting Started with Differential Expression
================

-   [Overview](#overview)
-   [Setting up](#setting-up)
    -   [Access Discovery](#access-discovery)
    -   [Organize your files](#organize-your-files)
    -   [Transfer your raw data to
        Discovery](#transfer-your-raw-data-to-discovery)
        -   [From your local computer](#from-your-local-computer)
        -   [From the sequencing center](#from-the-sequencing-center)
            -   [Note: check that the files were not
                corrupted](#note-check-that-the-files-were-not-corrupted)
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
expression analysis starting with the raw data directly from the
sequencer through to meaningful results files and visualizations.

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

##### From your local computer

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

##### From the sequencing center

You likely won’t be transferring sequencing data from your local
computer. Instead, the sequencing center will require you to transfer
your data from their servers to your computer or, in this case, to
Discovery. Luckily the protocol for doing this is not difficult.

First, you will need to [log in to Discovery’s Open On
Demand](http://ood.discovery.neu.edu/) in a browser page using your
Northeastern login. On this page, find the drop-down menu “Clusters” in
the top bar, then select `>_Discovery Shell Access`. This will open a
page that should look like the CLI you are familiar with.

Navigate to your project’s `raw_data` folder through this page, just
like you would if you were in a command line window. The sequencing
center will have sent information such as a username and password that
you will use, along with a set of instructions to transfer your data,
likely with a command like `sftp`. I will not be walking through these
steps here, as the specifics will vary company-by-company. Follow the
instructions provided by the sequencing center to transfer your data
through a Unix/Linux CLI. You can check that you have all the files you
expected with `ls -lh` in your `project/raw_data` directory.

###### Note: check that the files were not corrupted

It’s unlikely anything was corrupted in transfer, but it’s still a good
idea to check. If any files are different sizes than they are supposed
to be, that’s your first indication, but that won’t always happen. Every
file is encrypted with some kind of hash, often an MD5 hash. This is a
long string of letters and numbers. If the MD5 hash is different between
the files you transferred from your local computer or the sequencing
center server and the files you have on Discovery, that means they’ve
been corrupted somehow during the transfer process. On Discovery, you
can check the encryption hashes with this command:

``` bash
$ md5sum *.fastq.gz
```

If you have a Mac, you can use this same command on your local files
(sometimes `md5` if `md5sum` does not exist) . If you have a Windows
computer that can’t support Unix/Linux commands, you might be able to
[follow some of the steps listed
here](https://www.nextofwindows.com/5-ways-to-generate-and-verify-md5-sha-checksum-of-any-file-in-windows-10).

What is generated should be a list of long alphanumeric strings followed
by the respective file names. Check that these strings are the same
between the files you have on Discovery and the ones on the sequencing
center servers or your local computer. Any corruption will create a very
evident change in the hash. If this happens, try again to transfer the
corrupted files and check.

## Next steps

With your data successfully uploaded to the cluster, and with your files
organized, you’re ready to begin! The first step is [quality checking
your reads and trimming away low-quality
areas](Step_1_QualityTrimming.md).
