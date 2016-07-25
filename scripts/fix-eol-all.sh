#!/bin/sh
find data -type f \( -name '*.csv' -o -name '*.bib' \) -print0 | while read -d $'\0' file
do
    ./scripts/fix-eol.sh "$file"
done
