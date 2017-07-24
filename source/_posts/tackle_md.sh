#!/bin/sh

file_list="人工智能简介.md hdf5.md"
cd /Users/Aether/Documents/md/ && cp $file_list $HEXOMD && cd $HEXOMD

sh indent.sh
sh read_more.sh
for mdfile in $(ls *.md)
do
    awk -f ./title_size.awk $mdfile > /tmp/$mdfile && mv /tmp/$mdfile  $mdfile
done
