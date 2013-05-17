# Renames pdf to stadard name format
#to run type bash sh/renamePdf.sh ls data/   
cd data
for filename in *
do
   cd $filename
   for file in *.csv
   do
	perl -pi -e 's/\r/\n/g' $file
   done
   cd ..
done