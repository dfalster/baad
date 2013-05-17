# Copy import.csv into all data directories
for filename in data/* 
do
# git mv $filename/extra $filename/xtra
 git rm $filename/MetadataOLD*
done