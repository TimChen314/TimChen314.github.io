#!/bin/sh

#hostname=$(hostname)
#if [ "$hostname" = "TaodeMBP" ];then
#    file_list="hexo_shadowsocks备忘.md hexo_人工智能简介.md hexo_hdf5.md hexo_git.md"
#    cd /Users/Aether/Documents/md/ && cp $file_list $HEXOMD && cd $HEXOMD
#fi

sh indent.sh
sh read_more.sh
sed -i 's///g' *.md 

#for mdfile in $(ls *.md)
#do
#### change title size. Since I find that title size can be setted at file themes/next/source/css/_variables/custom.styl, this part is abandoned.
#    state=$(grep "^title: " $mdfile | grep "font size")
#    # if title size has not been set, then add title size
#    if [ -z "$state" ];then
#        awk -f ./title_size.awk $mdfile > /tmp/$mdfile && mv /tmp/$mdfile  $mdfile
#    fi
#
#### remove manual title size setting
#   sed -ie 's/<font size=7><b>//;s/<\/b><\/font>//' $mdfile
#done

