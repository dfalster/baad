![baad logo](https://github.com/dfalster/baad/raw/master/extra/baad.png)

# Setup

## Required packages

Building of the baad requires the package ['maker'](https://github.com/richfitz/maker), which is still under development.

### Other packages

A number of other packages are required to generate reports and the manuscript:

    rmarkdown, knitr, knitcitations, plyr, whisker, maps, mapdata, gdata, bibtex.

If you are going to lookup species names from Taxonstand and taxize (with the postProcess function), you will also need,

    taxize, Taxonstand, jsonlite

# Line endings

## Fix all line endings

We have had problems with Excel on OS X [which uses old line endings](http://developmentality.wordpress.com/2010/12/06/excel-2008-for-macs-csv-bug/), which tend to obscure diffs.  To avoid this problem, please set up a git hook that checks for line endings by running (in the project root directory)

```
ln -s ../../scripts/check_line_endings.sh .git/hooks/pre-commit
```

This will check that all files have unix endings once files have been staged (so after git's `crlf` treatment).  You can run it manually to check by running

```
./scripts/check_line_endings.sh
```

which looks at staged files only, or

```
./scripts/check_line_endings.sh csv
```

which looks at *all* csv files in the project, including uncommitted, unstaged, ignored files, etc.

To *fix* line endings, run

```
./scripts/fix-eol.sh path/to/file.csv
```
To fix *all* files in the project, run

```
./scripts/fix-eol-all.sh
```

which looks at all csv files, regardless of git status, ending correctness, etc.  It takes a few seconds to run.

## Windows users

In addition to the issue described above, Windows users must make sure that git is configured to commit with Unix-style line endings. This maintains the integrity of files on a Windows machine, while making sure the line-endings in the repository can be used by Mac (Unix) and Windows users alike.

When installing git-scm, make sure the setting

    Checkout Windows-style, commit unix-style line endings

is checked (the default).


# Rebuilding the database

The database can be rebuilt using maker. From R, run:

```
maker::make("output/baad.rds")
````

This will rebuild the database, and store a copy in `output/baad.rds`. To read this dataframe in `R`, use `readRDS`,

```
dat <- readRDS('output/baad.rds')
```

The database is stored as a list with components `data`, `contact` and `ref`. These contain the data (as a dataframe), contact information for the data providers, and references to publications (where available).

More information for interacting with the maker-generated database forthcoming...

# Adding datasets

[maker](https://github.com/richfitz/maker) offers no looping constructs (on purpose) so for now at least we generate the makerfile using [whisker](https://github.com/edwindj/whisker).  If you add a dataset, you will need to rerun the `bootstrap.R` script, which will update the `maker_data.yml` and `maker_reports.yml` files with appropriate rules for the new dataset (similarly if you remove datasets, do the same).
