#!/bin/bash
# $1  jaspreet1, jaspreet2

SCRIPTPATH=`pwd`

my_files=$(ls ./$1/*.png)
for my_file in ${my_files}; do
    echo -e "\n${my_file%.*}"
    python3 $SCRIPTPATH/normalize.py -v ${my_file%.*}.gt.txt
    sed -i -e 's/\xe2\x80\x8c//g' ${my_file%.*}.gt.txt
    OMP_THREAD_LIMIT=1 tesseract $my_file        ${my_file%.*} -l hin --psm 6 wordstrbox
	mv "${my_file%.*}.box" "${my_file%.*}.wordstrbox" 
	sed -i -e "s/ \#.*/ \#/g"  ${my_file%.*}.wordstrbox
    sed -e '/^$/d' ${my_file%.*}.gt.txt > ${my_file%.*}.tmp
    sed -e  's/$/\n/g'  ${my_file%.*}.tmp > ${my_file%.*}.gt.txt
	paste --delimiters="\0"  ${my_file%.*}.wordstrbox  ${my_file%.*}.gt.txt > ${my_file%.*}.box
    rm ${my_file%.*}.wordstrbox  ${my_file%.*}.tmp
    OMP_THREAD_LIMIT=1 tesseract $my_file ${my_file%.*} -l hin --psm 6 lstm.train
 done
