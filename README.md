
# BAAD: a Biomass And Allometry Database for woody plants

## About

The Biomass And Allometry Database (BAAD) contains data about the construction of woody plants across the globe. These data were gathered together from over 170 different published and unpublished scientific studies, most of which was not previously available in the public domain. It is our hope that making these data available will improve our ability to understand plant growth, ecosystem dynamics, and carbon cycling in the world's vegetation. The dataset is described in detail in the following article

	citation

## Using BAAD

The data in BAAD are released under the [Creative commons CC0 license](http://creativecommons.org/about/cc0), and can therefore be reused without restriction. To recognise the work that has gone into building the database, we kindly ask that you cite the above article, or when using data from one of the individual studies the original article.

There are two options for accessing data within BAAD.

### Download compiled database

You can download a compiled version of the database from either

1) Ecological Archives [XXX Add Link XXX]. This is the published version of the database.
2) Releases we have posted on [github](https://github.com/dfalster/baad/releases).

The database contains the following elements

- `data`: amalgamated dataset (table), with columns as defined in `dictionary`
- `dictionary`: a table of variable definitions
- `metadata`: a table with columns "studyName","Topic","Description", containing written information about the methods used to collect the data
- `methods`: a table with columns as in data, but containing a code for the methods used to collect the data. See [config/methodsDefinitions.csv](config/methodsDefinitions.csv) for codes.
- `references`: as both summary table and bibtex entries containing the primary source for each study
- `contacts`: table with contacts and affiliations for each study

These elements are available as both

1) a list within the file `baad.rds` (for use in R)
2) as a series of csv and text files.

Having downloaded the rds file, you can load it in `R`, using `readRDS`:

```
baad <- readRDS('baad.rds')
```

### Rebuilding from source

The BAAD can be rebuilt from source (raw datafiles) using our scripted workflow in R. Beyond base R, building of the BAAD requires the package ['maker'](https://github.com/richfitz/maker). To install maker, from within R, run:

```
install.packages("devtools")
devtools::install_github("richfitz/maker")
```

The database can then be rebuilt using maker. From R, run:

```
m <- maker:::maker()
m$make("export")
````

This will rebuild the database, and store copies in the folder `export` as both `rds` (compressed data for R) and also as csv files.

A number of other packages are required to generate reports and the manuscript:

    rmarkdown, knitr, knitcitations, plyr, whisker, maps, mapdata, gdata, bibtex.

If you are going to lookup species names from Taxonstand and taxize (with the postProcess function), you will also need,

    taxize, Taxonstand, jsonlite

These can easily be installed using maker

```
m <- maker:::maker()
m$install_packages()
```

## Contributing data to the BAAD

We welcome further contributions to the BAAD.

If you would like to contribute data, the requirements are

1) You collected biomass or size data for multiple individuals within a species
2) You collected either total leaf area or at least one biomass measure
3) Your biomass measurements (where present) were from direct harvests.

See [these instructions](extra/contributing.md) on how to prepare and submit your contribution.

Once sufficient additional data has been contributed, we plan to submit an update to the first data paper, inviting as co authors anyone who has contributed since the first data paper.

## Acknowledgements

We are extremely grateful to everyone who has contributed data. We would also like to acknowledge the following funding sources for supporting the data compilation. D.S. Falster, A. Vårhammer and D.R. Barneche were employed on an ARC discovery grant to Falster (DP110102086) and a UWS start-up grant to R.A. Duursma. R.G. FitzJohn was supported by the Science and Industry Endowment Fund (RP04-174). M.I. Ishihara was supported by the Environmental Research and Technology Development Fund (S-9-3) of the Ministry of the Environment, Japan. We thank Takahiro Inoue, Hayato Aoyama and Shin-ichiro Aiba for valuable assistance.

![baad logo](https://github.com/dfalster/baad/raw/master/extra/baad.png)
