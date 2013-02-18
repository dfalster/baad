# Renames pdf to stadard name format
#to run type bash sh/renamePdf.sh ls data/   
cd data
for filename in *
do
   echo $filename.pdf
   mv $filename/*.pdf $filename/pdf-$filename.pdf
#   mv $filename/import.txt $filename/import.csv
done