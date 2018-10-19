#!/bin/bash
#--------------------猫眼演出readme-------------------
#*************************mou1.0*******************
path="${CODE_HOME}my_code/"
file="${path}sh/${2}.sh"

cat_api() {
cat ${path}api.sh | head -$1 | tail -$2 >$file
}

if [ ${1}r == hr ]
then
echo "参数1为模式，n为常规模式，r为实时模式，e为etl模式。参数2为创建文件"
exit 0
elif [ ${1}r == nr ]
#加上任意字符，如r 避免空值报错
then
`cat_api 16 13`
elif [ ${1}r == rr ]
then 
`cat_api 33 16`
elif [ ${1}r == er ] 
then
`cat_api 50 16`
fi

echo "succuess! mode:normal path:$file"
