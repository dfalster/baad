# Copy import.csv into all data directories
for filename in data/* 
do
   cp makeDataFrame.R $filename
#   mv $filename/import.txt $filename/import.csv
done