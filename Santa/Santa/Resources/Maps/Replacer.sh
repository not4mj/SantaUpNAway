#!/bin/bash

cat mapLevel_$1_$2.tmx|sed 's/"78"/"156"/g' > temp1
cat temp1|sed 's/"100"/"200"/g' > temp2
cat temp2|sed 's/"1024"/"2048"/g' > temp3
cat temp3|sed 's/mapForSanta/mapForSanta-hd/g' > temp4
cat temp4|sed 's/metaSprites/metaSprites-hd/g' > mapLevel_$1_$2-hd.tmx