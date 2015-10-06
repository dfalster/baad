
Contributing to the BAAD
====================

## Reporting errors

If you notice a possible error in the BAAD, please [post an issue here](https://github.com/dfalster/baad/issues), describing the error and possible fix in detail. If you can, please provide code illustrating the problem.

## Contributing new data

We gladly accept new data contributions to BAAD. In the future we may try publish an updated data paper, including all new contributors as co-authors on the new article. 

If you would like to contribute data, the requirements are:

1. Data collected are for woody plants
2. You collected biomass or size data for multiple individuals within a species
3. You collected either total leaf area or at least one biomass measure
4. Your biomass measurements (where present) were from direct harvests, not estimated via allometric equations.
5. You are willing to release the data under the [Creative commons CC0 public domain waiver](http://creativecommons.org/about/cc0).
6. **That you make it is as easy as possible for us to incorporate your data by carefully following the instructions below.**

### Preparing data

To contribute, please follow the steps below. It is important that all steps are followed so that our automated workflow (Figure 1) proceeds without problems.

1. Create a new folder with name corresponding to the paper or study of the dataset, e.g. `Falster2014` (do not include `etal` or similar).
2. Prepare the following files:
	* `data.csv`: a table of data in comma-separated values format, with data for each individual plant on a single row
	* `dataImportOptions.csv`: options for reading in the the file `data.csv`
	* `dataManipulate.R`: a custom R function to manipulate data, if needed
	* `dataMatchColumns.csv`: a table matching variables in your data to variables in BAAD. Columns are as follows:
    * `var_in` are the column names of your data file `data.csv`, 
    * `unit_in`: the units of your data
    * `var_out`: the corresponding variable name in BAAD for this variable (from the table [`methodsDefinitions.csv`](https://github.com/dfalster/baad/blob/master/config/methodsDefinitions.csv))
    * `method`:  any relevant codes describing how you collected the data (from the table [`variableDefinitions.csv`](https://github.com/dfalster/baad/blob/master/config/variableDefinitions.csv).
	* `dataNew.csv`: any data you wish to add, not already in `data.csv`, e.g. site name, location, vegetation type. 
    * Note, we prefer you to add these details here, rather than modifying the raw data file, as the modifications are then automated and part of the workflow.
    * Substitutions are also possible, [as in this example](https://github.com/dfalster/baad/blob/master/data/Kohyama1994/dataNew.csv) where abbreviations in the variable `species` are used to add details such as family, and then to eventually replaced the abbreviation with species true name . 
	* `studyContact.csv`: contact details of data contributor(s). Please keep the number of contributors to one or two.
	* `studyMetadata.csv`: description of the methods used to collect the data.
	* `studyRef.bib`: reference for the study, in [bibtex format](http://en.wikipedia.org/wiki/BibTeX#Examples).

It may help to download one of the [existing datasets](https://github.com/dfalster/baad/tree/master/data) and use it as a template for your own files and a guide on required content. You should also look at the files in the [config folder](https://github.com/dfalster/baad/tree/master/config), in particular:
  * `variableDefinitions.csv`: names and descriptions of variables in BAAD
  * `variableConversion.csv`: list of unit conversions used
  * `methodsDefinitions.csv`: codes used to indicate methods used in collecting the data.

![baadworkflow](ms/Figure2.png)
**Figure 1** Workflow for building the BAAD. Data from each study is processed in the same way, using a standardised set of input files, resulting in a single dataset with a common format.

### Adding data to BAAD

#### Send us a pull request

By far our preferred way of contributing is for you to fork the database in github, add your dataset then send us a [pull request](https://help.github.com/articles/using-pull-requests/). If this is not possible, you could email the relevant files (see above) to [Daniel Falster](http://web.science.mq.edu.au/directory/listing/person.htm?id=dfalster) or [Remko Duursma](http://pubapps.uws.edu.au/teldir/personprocess.php?9764).

#### Adding your study

Once you have prepared your data files, add the relevant folder into the `data` directory. You can then rebuild the dataset, including your dataset.

To do so you will need to rerun the `bootstrap.R` script, which will update the `maker_data.yml` and `maker_reports.yml` files with appropriate rules for the new dataset (similarly if you remove datasets, do the same). (At this stage, [remake](https://github.com/richfitz/remake) offers no looping constructs (on purpose) so for now at least we generate the remakefile using [whisker](https://github.com/edwindj/whisker).)

#### Agree to license conditions

When you send the pull request or email, please indicate that you are willing to release the data under the [Creative commons CC0 public domain waiver](http://creativecommons.org/about/cc0).

## Other contributions

If you would like to value-add to BAAD in some other way, please get in contact, either via [email](https://github.com/dfalster/baad/blob/master/config/contact.csv) or by [posting an issue](https://github.com/dfalster/baad/issues) with an idea or offer of time. 
