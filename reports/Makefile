output = "../output/reports"

all: $(output)

$(output):
	Rscript -e 'source("report-fun.R"); printAllStudyReports(studynames=c("Selaya2007", "Selaya2008", "Selaya2008b"), reprocess=FALSE, path=$(output))'

clean:
	rm -fr $(output)

.PHONY: all clean
