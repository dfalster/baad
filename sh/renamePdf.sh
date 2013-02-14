# Copy import.csv into all data directories
cd data
for filename in *
do
   echo $filename.pdf
   mv $filename/*.pdf $filename/pdf-$filename.pdf
#   mv $filename/import.txt $filename/import.csv
done