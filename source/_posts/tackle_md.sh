#!/bin/sh

hostname=$(hostname)
if [ "$hostname" = "TaodeMBP" ];then
    file_list="Mou_shadowsocks备忘.md Mou_人工智能简介.md Mou_hdf5.md Mou_git.md"
    cd /Users/Aether/Documents/md/ && cp $file_list $HEXOMD && cd $HEXOMD
elif [ "$hostname" = "PC-20150409TELT" ];then    
    # PC-20150409TELT is lab computer.
    file_list="Story_of_Terminal.md"
    cd /c/Users/Administrator/Desktop/笔记 && cp $file_list $HEXOMD && cd $HEXOMD
fi

sh indent.sh
sh read_more.sh
for mdfile in $(ls *.md)
do
    awk -f ./title_size.awk $mdfile > /tmp/$mdfile && mv /tmp/$mdfile  $mdfile
done
