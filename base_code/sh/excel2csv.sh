#!/bin/bash
#Description: csv excel 格式转换
if [ $1 = h ];then
    echo "1:input_file 2:output_file 3:sheet_num[0,1,2,...]"
else
    tmp="$HOME/Documents/tmp.xlsx"
    cp $1 $tmp
    python ${public_home}/base_code/py/excel2csv.py $tmp $2 $3
    rm $tmp
fi
