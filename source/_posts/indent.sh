#!/bin/sh
for mdfile in $(ls *md)
do
    # indent for code block
    code_block_state=$(grep "^\`\`\`[a-z]" $mdfile)
    #echo $code_block_state "code_block_state test"
    if [ -n "$code_block_state" ];then
        sed -i 's/^```[a-z]/   &/g' $mdfile
    fi

    # indent for quote
    quote_state=$(grep "^>" $mdfile)
    #echo $quote_state "quote_state test"
    if [ -n "$quote_state" ];then 
        sed -i 's/^>/   &/g' $mdfile
    fi
done
