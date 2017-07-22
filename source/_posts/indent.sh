#!/bin/sh
# indent for code block
sed -i 's/^```[a-z]/   &/g' *.md
# indent for quote
sed -i 's/^>/   &/g' *.md
