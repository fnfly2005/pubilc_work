#!/bin/bash
#--------------------猫眼演出readme-------------------
#*************************mou1.0*******************
path="${CODE_HOME}my_code/"
file="${path}sh/${2}.sh"

if [ ${1}r == nr ]
#加上任意字符，如r 避免空值报错
then
cat ${path}api.sh | head -16 | tail -13 >$file
echo "succuess! mode:normal path:$file"
elif [ ${1}r == rr ]
then 
cat ${path}api.sh | head -33 | tail -16 >$file
echo "succuess! mode:realtime path:$file"
elif [ ${1}r == hr ]
then
echo "参数1为模式，n为常规模式，r为实时模式，参数2为创建文件"
fi
