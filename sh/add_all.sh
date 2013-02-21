# Copy import.csv into all data directories
for filename in data/* 
do
   cp dataNew.csv $filename
#   mv $filename/data_new.csv $filename/dataNew.csv
#	touch $filename/dataManipulate.r
done