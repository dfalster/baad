TODO
Structural items
* function to create std files for a new study
* write user manual
* change use of "raw", conflict with function name
* untested function to find and replace
fn <- list.files(pattern="\\.R", recursive=TRUE, full.names=TRUE)
for(i in 1:length(fn)){
   r <- readLines(fn[i])
   r <- gsub("raw","rawdata",r)
 writeLines(r, fn[i])
}

Data issues
* Change variable.match file on folder Epron 2012, line 11, column var_out: from h.t to c.d -> I put a question to the authors to figure out what variable this actually is, it is not clear from their dataset and explanations
* Change variable.match file on folder Kohyama 1987, line 5, column var_out: from d.cr to d.cr2 -> I already added the variable d.cr2 to the variable.definitions.csv file, but for the moment we will use d.cr to compare the newer output datasets with the older ones.
* Same thing as above for Kohyama1994, line 4, column var_out
* Same thing as above for Sterck2001, line 6, column var_out
* Delete lines 4,6,8,10 (fresh mass variables, not to be used) in variable.match.csv from folder Wang2011
* Check references for Domec 2012. Previous version had 3 different references. Do we need to split into more studies?
* Check references for Kenzo 2009
* Mistake in Rodriguez2003/dataManipulate.r crown classes are all the same??. Fix and move to dataNew.csv
* McCulloh2010 - check we are only taking largest individual, as rest are branch level data

#----------------------------------------------------------------------------
2013.03.06 Finished import restructure

* Add extra columns to dataNew.r files called 'source' For existing data put from paper and name of person in brackets. [done]
* Reformat/check the new variable match files you made yesterday so that they include all the columns in data.csv. [done]
- move items from dataManipulate to dataMatchColumns [done]
- fix checknames ==TRUE [done]
* function to load all data. Checks first if file already present in output/data/, if not creates one by importing. Option to reimport all [done]

#----------------------------------------------------------------------------
2013.03.01 Sent update to coauthors
Made plotting function
Fixed several unit problems (Epron, Osunkoya, Rodriguez, O'Grady, Wang, ??)



#----------------------------------------------------------------------------
2013.02.21 Major restructure complete
The biomass database has been majorly reworked and is now ready for next stage. Diego and I worked together on a  lot of the bits, and succeeding in using git to merge our various contributions. throughout the restructure we used a test script to ensure that we didn't break anything. This was very helpful because we did break a lot of things. We need to document it some more. But overall it's much simpler, cleaner and easier to read. I'm VERY happy with current structure.

varibale.match.csv file got split into folder-specific files for each study without the first column and with a new column called notes that combines the information from the three previous notes columns. Functions updated accordingly.

#----------------------------------------------------------------------------
2013.02.20 Hackathon, Diego and Daniel

Diego - split variable match file
Daniel - new import template for single study

Next - 
- split apart makeDatafile functions for all other studies
- use variable match file to replace columns in raw

#----------------------------------------------------------------------------
2013.02.19 Meeting with Remko

1. Workflow. 
- don't go as far as making database. What we have is nice. So long as it is traceable and works. 

2. Coauthorship
- For papers published prior to 1990, agree that we will not attempt to contact authors, provided data publicly available. 

3. Shared google spreadsheet
- only use this for assembling new data. 
- remove all info except study name once imported. 

TODO:
1. Review Japanese database
2. Review variable names

#----------------------------------------------------------------------------
2013.02.13 Advice from Rich about how to cleanup, make more transparent. 

1. Put under version control. git, stored on bitbucket [ done]
With Rich's help, we have put the whole project under version control, using git
https://bitbucket.org/dfalster/baad

2. Clean up files and directory structure [done]

3. Remove bad variable names
 - F and T for FALSE, TRUE [done]
 - names [done]
 - match 

3. Introduce test scripts [done]

4. write new import system, check against old
- break old import into functions, so that can run for individual studies. [done]
- change variable names to exact names using check.names=FALSE [FAIL. Tried this but ran into issues. Changes stashed on branch CheckLinesOnImport]
- break apart old data files [part done - all info custom to study now in it's directory]
- split var.match table into parts 
- data always stored in files
- use translation tables to change species names etc
- to achieve all of this, make new system in parallel, check against old, then delete old
- remove pdf, instead store bibtek file with DOI and URL
- change c(3:12, 14:37, 39:45) in import (makeDataFrame.R) to something more robust, e.g. colnames

5. Possibly move to SQLite database.  

6. Review list of variable names in each category

#----------------------------------------------------------------------------
2013.02.06 Finished first import of data
We have data for 9278 individuals from 56 studies covering 319 species! 

Sent instructions to Diego for next phase. Goal is to send out a brief report to contributors within the 2 weeks, and a more detailed report within a month.

Spoke to Greg Wilson (Software carpentry) about where to host data. He suggests datadryad - can release versions, just link to first version in ecology paper, then push an updated version on some frequency (say every year). 

#----------------------------------------------------------------------------
Meeting 2012.09.13 Daniel & Remko

SPECIFIC QUERIES TO DISCUSS
* van breugel et al:  willing to supply total biomass but not leaf biomass
--> exclude
* latitude and longitude format --> not standardised. 
--> decimal degrees
* What to do about hybirds/ clones: leMaire ( Euc hybrids sent us data already) and Ryan group (Euc clones)
--> include but indicate in description somewhere 
* Myster: all seedlings same size. Similar for Aiba 2007. Not sure how this is useful
--> Include any data we have, just don't seek other data

#-----------------------------------------------------------------------

Meeting 2012.07.12 Daniel & Remko
* Update on spreadsheet progress
 --> move to google docs
 --> backup folder created in x_archive

* Agree to employ someone to help us with project
--> ideally based at mq, on thursdays so overlapping with Remko
--> Df to talk with Doug
--> also collect list of grunt tasks: anyone could do this anytime 

#----------------------------------------------------------------------
2013.11. Diego employed, continuing through until May

#----------------------------------------------------------------------

2012.09.13 Remko has funds to employ someone for a month

Grant idea - online database like palaeobiology database or PALS
http://paleodb.science.mq.edu.au/cgi-bin/bridge.pl?a=home

PBDB run by Alroy & Kosnik
Possibly borrow infrastructure from them, and involve them in grant
Ask them how they dealt with conflict of people contributing data
 - each contribution is an electronic publication


#----------------------------------------------------------------------
Meeting 28/06/12 10:00 Allometry database project, Daniel & Angelica

OVERVIEW OF RESPONSES
- Numbers, types of datasets

SPECIFIC QUERIES
- Mori --> done
- acknowledging receipt of data (emails) --> need to do this
- latitude and longitude format --> not standardised 

SUMMARY OF DAYS WORKS BY Angelica and where
2/03/12	MQ
9/03/12	MQ
16/03/12	MQ
23/03/12	MQ
30/03/12	MQ
3/04/12	MQ
13/04/12	MQ
20/04/12	MQ
27/04/12	MQ
4/05/12	MQ
11/05/12	MQ
18/05/12	MQ
25/05/21	MQ
30/05/12	MQ
1/06/12	MQ
6/06/12	MQ
7/06/12	MQ
14/06/12	UWS
15/06/12	UWS
18/06/12	UWS
20/06/12	UWS
21/06/12	UWS
25/06/12	UWS
26/06/12	UWS
27/06/12	UWS
28/06/12	UWS
29/06/12	UWS
2/07/12	UWS
3/07/12	UWS
4/07/12	UWS
5/07/12	UWS
6/07/12	MQ

#-----------------------------------------------------------------------

Meeting 28/06/12 10:00 Allometry database project, Remko, Daniel & Angelica

OVERVIEW OF RESPONSES
- Numbers, types of datasets

SPECIFIC QUERIES
- What to do when one person sends data which has been used in papers written by someone else/has been collected by someone else
Ask in the email if there should be any other authors. Each dataset need a contact person
- Multi dataset people - special email or find individual papers and email individual authors
wait until later
- Minimum number of individuals for inclusion
6 - 15 depending on size and range, eg large trees are more work 
- Dead line for sending data
No dead line, put in reminders, end of the year
- Some don't have leaf mass or leaf area but have large datasets of other variables, should they be included?
e.g. Harja, Lines
yes include
- Go through who should keep correspondence with whom
- Bond-Lamberty's equation dataset
not at the moment
- What to respond when they say they want to help with writing and analysis etc. (Ribeiro)
little content beyond gathering data, thanks
- When to visit UWS
- Lusk dataset - more biomass records than Yplant files?
- Psychotria data - all clear from Fernando


FORWARD PLANNING
- Angelica working one more week. Any opportunity to extend?
- DF away next Thursday
 
#-----------------------------------------------------------------------
2012.06.07 10:30 Allometry database project, Remko, Daniel & Angelica

Agenda
1. INTRODUCTIONS

2. REVIEW OF PROGRESS
- Angelica update us on summary dataset 
- Remko update on his datasets (incl Lusk)
- Daniel update on draft email and abstract
 --> happy with resoln on 'allocation'?
 --> contact Ecology to check about long-authorship list?
 --> webpage?

3. FORWARD PLANNING
a) Literature search

b) Compiling existing datasets
- Remko
- UWS
- lit search
- Aiba, Martin, Lusk, Duursma, Psychotria, Yplant, Sterck

c) Programming
- import functions for each dataset
- error checking script
- draft analysis script 

e) Contacting authors re contributing data

f) Employment & calendar
- UWS employment details and site visit for Aneglica
- days working
- next meeting

g) Task lists for all

2012.05.24 Meeting with Remko - agreed on approach forward
 - first publish a data paper in Ecology, with any individual providing at least 20 datapoints invited to be a coauthor
 - later publsih an analysis paper with restricted authorship (Falster, Lusk, Duursma, Varhammer if suiatble)
 - this allows us to take an inclusive approach towards coauthorship, with all contributors receiving citation credits whenever the paper is used. Easy ecology paper. 

Angelica can 
- draft emails to authors in my email account: save and don't send --> for me to approve
- collate data from hawkesbury plots
- check appendices of Chave - follow original data sources






