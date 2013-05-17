## Data issues

* Change variable.match file on folder Epron 2012, line 11, column var_out: from h.t to c.d -> I put a question to the authors to figure out what variable this actually is, it is not clear from their dataset and explanations
* Change variable.match file on folder Kohyama 1987, line 5, column var_out: from d.cr to d.cr2 -> I already added the variable d.cr2 to the variable.definitions.csv file, but for the moment we will use d.cr to compare the newer output datasets with the older ones.
* Same thing as above for Kohyama1994, line 4, column var_out
* Same thing as above for Sterck2001, line 6, column var_out
* Delete lines 4,6,8,10 (fresh mass variables, not to be used) in variable.match.csv from folder Wang2011
* Check references for Domec 2012. Previous version had 3 different references. Do we need to split into more studies?
* Check references for Kenzo 2009
* Mistake in Rodriguez2003/dataManipulate.r crown classes are all the same??. Fix and move to dataNew.csv
* McCulloh2010 - check we are only taking largest individual, as rest are branch level data
* In Delagrange0000a and Delagrange0000b there are a few "#DIV/0!"
  entries (divide-by-zero errors) -- these are currently flagged as
  NA, but should be chased up.
* Does stem mass, i.e., 'm.st', include branch mass? Our definition of m.st is the sum of heartwood mass (m.sh), sapwood mass (m.ss) and bark mass (m.sh). Some studies, e.g., Ilomaki2003, have both m.st and another stem measure that excludes branch mass.
* check the dataset from Epron2012, there is something wrong with h.t, a.cp and/or a.cs the data do not match.

* Plots to check out with Remko (possible outliers):
	 - a.cp-vs-h.c = Aiba2007
	 - a.cp-vs-lf.sz = Osada2003,Osada2005,Peri's papers
	 - a.cp-vs-m.st = Albretkson1984
	 - a.cs-vs-d.st = both plots
	 - a.lf-vs-a.ssbc = I can't tell what could be wrong, sorry
	 - a.ssbc-vs-h.t = which one is likely to be wrong?
	 - a.ssbc-vs-h.c = same as above


