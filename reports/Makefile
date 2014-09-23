output1 = "../output/report-by-study"
output2 = "../output/report-by-var"

all: $(output1) $(output2)

$(output1):
	Rscript -e 'source("report-fun.R"); printAllStudyReports( reprocess=FALSE, path=$(output1))'

$(output2):
	Rscript -e 'source("report-fun.R"); comparePlots(reprocess=FALSE, path=$(output2))'

clean:
	rm -fr $(output1) $(output2)

.PHONY: all clean
