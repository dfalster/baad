
# writing reports using knitr #

See introductory material here

- http://www.rstudio.com/ide/docs/authoring/using_markdown
- http://jeromyanglim.blogspot.com.au/2012/05/getting-started-with-r-markdown-knitr.html

Turn any script into a report

    `system.file("misc", "knitr-template.Rmd", package = "knitr")`

Use whisker package to generate new Rmd files for each study

# Process for importing a new study #

a list

- 
- 

# Setting up git repository on local machine#

##Fix bad line endings from in csv files from mac version of Excel
Add the following text to .git/config
This must be done on **each clone**

[filter "cr"]

    clean =  tr '\\r' '\\n'

    smudge = tr '\\n' '\\r'





 
