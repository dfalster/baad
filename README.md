
# Setup

This compilation requires package ['dataMashR'](https://github.com/dfalster/dataMashR), which is still under development.

To ensure we use the right version of dataMashR we are using using git's [submodules feature](http://git-scm.com/book/en/Git-Tools-Submodules).

To setup existing submodules after cloning run

	git submodule init
	git submodule update

To update submodule to correct version:

	git submodule update

You can then install the package locally (into the folder `/lib`) by running

    make install-dataMashR

# Line endings

We have historically had problems with Excel on OS X [using old line endings](http://developmentality.wordpress.com/2010/12/06/excel-2008-for-macs-csv-bug/), which tend to obscure diffs.  To avoid this please set up a git hook that checks for line endings by running (in the project root directory)

	ln -s ../../scripts/check_line_endings.sh .git/hooks/pre-commit

This will check that all files have unix endings once files have been staged (so after git's `crlf` treatment).  You can run it manually to check by running

	./scripts/check_line_endings.sh

which looks at staged files only, or

	./scripts/check_line_endings.sh csv

which looks at *all* csv files in the project, including uncommitted, unstaged, ignored files, etc.

To *fix* line endings, run

	./scripts/fix-eol.sh path/to/file.csv

To fix *all* files in the project, run

	./scripts/fix-eol-all.sh

which looks at all csv files, regardless of git status, ending correctness, etc.  It takes a few seconds to run.
