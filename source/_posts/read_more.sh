#!/bin/sh

# if no "<!-- more -->" in *.md file, adding it into the file.
for md_file in $(ls *md)
do
    stat=$(grep "<!-- more -->" $md_file)
    if [ -z "$stat" ];then
        sed -i '20a <!-- more -->' $md_file
    fi
done

