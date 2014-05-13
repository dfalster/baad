output = "../output/reports"

all: $(output)

$(output):
	Rscript -e 'source("report-fun.R"); printAllStudyReports(reprocess=FALSE, path=$(output))'

clean:
	rm -fr $(output)

.PHONY: all clean
