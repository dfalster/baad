# Renames pdf to stadard name format
#to run type bash sh/renamePdf.sh ls data/   
cd data
for filename in *
do
   cd $filename
   mv extra xtra
   mkdir xtra
   mv *.pdf xtra
   mv *.xls xtra
   mv *.xlsx xtra

# rm -r -f extra
   # rm *.xlsx
   cd ..
#   mv $filename/import.txt $filename/import.csv
done