#!/bin/bash

cat mapLevel_$1_$2-hd.tmx|sed 's/"156"/"312"/g' > temp1
cat temp1|sed 's/"200"/"400"/g' > temp2
cat temp2|sed 's/"2048"/"4096"/g' > temp3
cat temp3|sed 's/-hd.png/-ipadhd.png/g' > mapLevel_$1_$2-ipadhd.tmx