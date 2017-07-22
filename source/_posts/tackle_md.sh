#!/bin/sh

sh indent.sh
sh read_more.sh
for mdfile in $(ls *.md)
do
    awk -f ./title_size.awk $mdfile > /tmp/$mdfile && mv /tmp/$mdfile  $mdfile
done
