Intro 4: Best Practices in Programming and Analysis
================

-   [Overview](#overview)
-   [Tips](#tips)
    -   [Stay organized.](#stay-organized)
    -   [Minimize nesting directories.](#minimize-nesting-directories)
    -   [Use descriptive file names.](#use-descriptive-file-names)
    -   [Back up your work.](#back-up-your-work)
    -   [Comment everywhere.](#comment-everywhere)
    -   [Try things.](#try-things)
    -   [Know how to debug.](#know-how-to-debug)
        -   [Printing](#printing)
        -   [Commenting lines out](#commenting-lines-out)
    -   [Document everything.](#document-everything)
    -   [Don’t be afraid to start over.](#dont-be-afraid-to-start-over)
    -   [Know where to look for help.](#know-where-to-look-for-help)
        -   [Documentation](#documentation)
        -   [Error messages](#error-messages)
        -   [Google and Stack Overflow](#google-and-stack-overflow)
        -   [Northeastern IT](#northeastern-it)

## Overview

At the risk of being pedantic, below are a few tips in no particular
order that I promise will make your life much easier if you make an
effort to utilize them. If you are a beginner with programming, practice
these early and often so they become second nature.

## Tips

#### Stay organized.

I said no particular order, but this is absolutely #1. Analyses grow
exponentially, and if you have a mess of files and directories it can
quickly become a nightmare to try to navigate everything. Staying
organized not only keeps you sane, it also makes your work quicker and
of higher quality. I’m definitely guilty of becoming disorganized at
times, but it’s a lot easier to start off organized and stay that way
than it is to try to do everything and regroup later, so find a system
that you can stick to. I recommend creating a directory for each project
containing sub-directories like `/data`, `/results`, and `/logs`, with
additional directories as necessary (for example, `/metadata`,
`/images`, and so on).

#### Minimize nesting directories.

The shorter you keep your paths, the better. This goes somewhat
hand-in-hand with staying organized. Not having to sift through multiple
sub-directories makes it much easier to find files and include paths in
scripts.

#### Use descriptive file names.

This again goes along with staying organized, but is also often required
for most analysis work. A lot of analysis involves batch-processing
files in a directory, such that some action is performed on each file
the same way. Files are most easily chosen to be included in the
analysis based on their names, so be consistently descriptive.
Information to put in file names includes animal number, treatment,
date, and other relevant conditions
(e.g. `AM1_Control_Spine_01JAN22.csv`). This doesn’t mean that your file
names have to be exceedingly lengthy, but trust me you’d rather have a
long and specific name than a short and unhelpful one. **DO NOT** use
spaces or other special characters like quotes in your file names, as
these can royally screw up certain functions. Use underscores instead of
spaces, and find a way around others (`pct` for `%`, for example).

#### Back up your work.

This is good practice both locally and remotely. On Discovery, make sure
you regularly copy or move files from `/scratch` to `/work`, because
files in `/scratch` are deleted after 30 days. Locally, I suggest using
something like Time Machine (on Mac) or the tried-and-true flash drive.
There are also larger drives with terabytes of storage that you can back
up your entire OS onto. Finally, your Northeastern student Outlook
account provides a straightforward cloud storage system. Anything can
happen, and if the only copy of your data and results are wiped from
`/scratch` or stored on an unusable computer there’s not always a way to
recover them.

#### Comment everywhere.

This becomes relevant when you are writing your own scripts. Comments
are commonly preceded by `#` (this is true for shell, Python, and R) and
will not be executed as code. Most of the time, when you revisit an old
script, you will forget what exactly you were doing and why. Comments
allow you to provide explanation and side information that make
returning to previous work much smoother, especially in long scripts.
Here’s an example in Python.

``` python
# Initializing list to contain numbers
list=(1, 2, 3, 4, 5)

# Looping through example list
for item in list:
  # Selecting numbers < 3
  if item < 3:
    # %item connects value for item to the output
    print("%i is less than 3"%item)
  # A different output for numbers = 3
  elif item==3:
    print("%i is equal to 3"%item)
  # A different output for numbers > 3
  else:
    pass
    # The below 'print' will be suppressed because it is commented out
    # print("%i is greater than 3"%item)
```

    ## 1 is less than 3
    ## 2 is less than 3
    ## 3 is equal to 3

This is a very short and simple script, so comments aren’t 100%
necessary, but as scripts get longer and more involved comments will
save you, and potentially others, a lot of headaches trying to decipher
your work. Use them liberally.

#### Try things.

When starting out, it can be tempting to think of codes the way you
would any other static document. That is, that there is one “final”
output and you have to get your script as close to that “final” draft as
possible on your first iteration to minimize later editing. In fact,
nearly the opposite is true. This is why software and operating systems
and so on are always being upgraded to new versions - they’re new
drafts, with more bugs worked out and more capabilities built in.

As with research, most of what you try will fail, so much so that you
will become suspicious when something *does* work on a first go (“It
worked, so it must be wrong!”). Trying to create a near-final first
draft can quickly paralyze you, or worse, prevent you from learning new
things. Think about what your input is, what you want your output to be,
and then break down the steps from point A to point B into tiny pieces.
Then try to tackle piece 1. If (when) your first approach fails, try a
new approach. Start small, and start *somewhere*.

There’s a saying in programming: “First make it functional, then make it
fast”. Your code doesn’t have to be pretty or ultra-efficient,
especially at first, it just has to do what you want it to.

#### Know how to debug.

Being able to test your work is incredibly important. Debug as you go -
you might not catch everything, but you’ll minimize errors compounding
on themselves. Otherwise you could write an entire script, only to
execute it and have no idea what went wrong. There are two absolutely
essential tools to have under your belt for debugging: printing and
commenting lines out.

##### Printing

Print things before you perform an action on them! In Python and R, the
command is `print()`; in bash, it’s `echo`. Using a ‘for’ loop over
files in a directory? Print the file names before performing your
action - that way you know your loop is defined correctly, and that only
the desired files are included. Creating a new variable? Print the
variable to make sure it’s read properly. Want to test just about
anything? Print the output every step of the way, before any further
manipulation.

##### Commenting lines out

As I introduced [above](#comment-everywhere), comments are your best
friend. Not only can you keep notes on what you’ve written, you can use
comments to diagnose bugs in your code. Say you have a ‘for’ loop
performing three different actions on your input, and your output is
incorrect but you don’t know which action made things go wrong. Place a
`#` before all of the actions, and use `print()` to make sure you are
looping over what you intend to. Then, un-comment action 1 and run. Did
it work? Re-comment out action 1, un-comment action 2, and run. Continue
like this, perhaps in different combinations, to see what could be the
issue. See [the section on comments](#comment-everywhere) for a very
brief example of what commenting out lines does.

#### Document everything.

This is a core tenet of research in general. With bioinformatics work,
make note of the software packages used and their versions, as well as
the parameters you used in a given run. Luckily, when you [run a queued
job on Discovery](Intro_2.md), a `slurm` file is automatically generated
that is a log of the run. This *does not always* contain the information
you might need to include in a methods section, so while it is useful,
make note of your own relevant information anyway.

#### Don’t be afraid to start over.

This advice comes with two major caveats: start over *if you are
confident you can now do it right*, and remember that you aren’t
starting entirely from scratch - you already know where the pitfalls
are. Most of what you do will fail; you will get errors you expected,
errors you didn’t expect, and errors that make you want to throw your
computer out the window. In running and re-running scripts to overcome
these errors, you accumulate a lot of “junk”: files that are incorrectly
formatted or out-of-date, buggy scripts, inconsistent environments, and
directories that don’t contain anything you need. But you will also
accumulate things that *did* work. So from the mess pluck out the raw
data, scripts that are debugged, relevant logs, and any outputs you can
use downstream. Burn the rest.

I’ll give a personal example to illustrate my point. When I first
attempted an RNA-Seq differential expression analysis, it took me a long
time to reach a point where I could even attempt the “differential
expression analysis” step. Before that were many weeks of trying and
re-trying quality trimming, quantification, and so on. When I finally
got all my scripts working, I had so many “interim” files that I
couldn’t tell what was what (stay organized and use descriptive file
names!). But I had raw data, a few supporting files, and debugged
scripts. I put everything that worked into one directory and locked away
“everything else” in another one. Then I restarted. Having ironed out
most of the errors, my second attempt took one week. A separate analysis
I did later took two days. You will constantly improve, but sometimes
you need to go scorched-earth on your earlier work to do it right.

#### Know where to look for help.

Do you know every single word in any language, its definition, and how
to use it properly in a sentence? Of course not. Neither do programmers
when it comes to programming languages. There are, as with any language,
“words” that you’ll use frequently and be “fluent” in, but there is no
expectation that you memorize every single command and its use. Knowing
where to find information to write and debug your codes is the primary
skill necessary to do any coding.

##### Documentation

Just about any package you will use is accompanied by *documentation*
(“docs” for short). Documentation is that package’s “dictionary” and
acts as a guide for the user to know what commands are available, what
kind of objects you can create or use, and how different components
interact. Documentation is akin to using the `--help` or `man` flags [in
the command line](Intro_1.md).

Here are a few examples of some different styles of documentation:

-   [Python](https://docs.python.org/3/)
-   [cellpose](https://cellpose.readthedocs.io/en/latest/index.html)
-   [plotly](https://plotly.com/python/)
-   [Trinity](https://github.com/trinityrnaseq/trinityrnaseq/wiki)

When first drafting a script using a particular language or package,
start by reading the documentation for the commands you might want to
use. It goes without saying, but you will save yourself many hours of
debugging by using your commands correctly in the first place!

##### Error messages

Believe it or not, the errors produced by a bug do not exist just to
frustrate you. Error messages are incredibly useful because they tell
you about what went wrong, sometimes including the exact line number
where the error came from. For example, a `package not found` error
means exactly that - the package isn’t installed at all or it’s
installed in the wrong place. A `FileNotFound` error in Python means,
you guessed it, the file does not exist or isn’t in the right spot. A
`ValueError` indicates that you are trying to use a variable that hasn’t
been defined. Read your errors!

Side note: this is why scripts that “fail correctly” are so aggravating.
They don’t produce what you want, but they also don’t raise errors so
you don’t know where to fix things. If something doesn’t work right, I
would almost always rather receive an error than not.

##### Google and Stack Overflow

The likelihood that you are the first person ever to try a certain
command or encounter a particular error is slim (but never 0). This is
where Google is your best friend. You can search for commands to do what
you want, search the errors you’ve received, search for the
documentation pages themselves, and so on. Most of coding is knowing
what to Google to take you to the information that you need.

Where this Googling will often lead you to is [a forum called Stack
Overflow](https://stackoverflow.com). Users publicly post questions
about errors they’ve received, commands they don’t know how to use, and
many other different issues. Other users then respond to these questions
and often include example code and other information walking you through
it. Some questions and their answers are better than others, but
nonetheless Stack Overflow is a very valuable resource. **DO NOT** take
answers on Stack Overflow as gospel and simply copy-paste code snippets.
Rather, learn to find quality answers, adapt them to your own use, and
make an effort to understand what is happening so you avoid those same
issues in the future. Make note of how others ask their questions and
what makes a “good” question, so that when you need to post your own you
can get the best help possible.

##### Northeastern IT

If you’ve encountered a beast of an error on the Discovery cluster that
you simply don’t know how to overcome even after extensive Googling, you
can always [submit a service ticket to
IT](https://service.northeastern.edu/tech?id=index_nu). They can work
with you on the issue and offer free consultations for users to discuss
specific problems. It’s not always quick, so you will likely need to
continue working at it in the meantime, but the people in IT are very
knowledgeable and willing to help.
