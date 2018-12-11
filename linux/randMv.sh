#!/bin/bash
# this shell script is for move png images from $1 to $2 randomly
# use $RANDOM as random generater 
j=1
if [ ! -d $1 ];then
    echo $1
    echo "\$1 is not dir or doesnot exist"
    exit 1
fi
if [ ! -d $2 ];then
    echo $2
    echo "\$2 is not dir or doesnot exist"
    exit 1
fi""
count=0
for i in $(ls $1/*.png); 
do
    if [ $(($RANDOM%1000)) -lt 40 ];then   #about 4% of imgs will be moved to $2
        mv $i $2
        count=$((${count}+1))
    fi
done
echo "${count} imgs move done"
