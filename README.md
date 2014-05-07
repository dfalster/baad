
# Setup

This compilation requires package ['dataMashR'](https://github.com/dfalster/dataMashR), which is still under development.

To ensure we use the right version of dataMashR we are using using git's [submodules feature](http://git-scm.com/book/en/Git-Tools-Submodules).

To setup existing submodules after cloning run

	git submodule init
	git submodule update

To update submodule to correct version:

	git submodule update

You can then install the package locally (into the folder `/lib`) by running the script

    ./update_dataMashR


