#!/bin/sh
find data -name '*.csv' -print0 | while read -d $'\0' file
do
    ./scripts/fix-eol.sh "$file"
done
