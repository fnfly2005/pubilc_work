#!/bin/bash
#数组
ar=(12 443 32 5 500 27 200 64)

let len=${#ar[@]}-1

echo -e "[\c"
for i in $(seq 0 $len);
do
    echo -e "${ar[$i]}\c"
    if [[ $i -ne $len ]];
    then
        echo -e ",\c"
    fi
done
echo "]"
