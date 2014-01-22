RUN_TESTS="library(testthat); test_dir('.')"

test:
	Rscript -e $(RUN_TESTS)

.PHONY: test
