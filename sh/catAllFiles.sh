# Copy import.csv into all data directories

rm R-working/merged.r

for filename in data/* 
do
	echo " " >> R-working/merged.r
    echo $filename >> R-working/merged.r
	cat $filename/makeDataFrame.R >> R-working/merged.r
done