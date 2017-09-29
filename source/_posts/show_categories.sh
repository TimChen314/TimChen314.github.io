#!/bin/sh
echo "Categories Info: "
grep categories *md | grep ":" | awk -F ':' '{print $3}' | sed 's///g' | sed "s/ *$//g" | sort | uniq | awk '{printf $0", "}END{printf "\n"}'
#comment of above line:        | print categories        |remove       | remove blank   |             | print in one line

echo "Tags Info: "
grep tags *md | grep ":" | awk -F ':' '{print $3}' | sed 's/^M//g' | sed "s/ *$//g" | sort | uniq | awk '{printf $0", "}END{printf "\n"}'
