#!/usr/bin/bash
#批量替换工具
if [[ ${1}r == hr ]];then
    echo "批量替换工具 参数1为原字符 参数2为新字符 参数3为路径"
else
    LC_CTYPE=C sed -i '' 's/'$1'/'$2'/g' \
    `grep $1 -rl ${3}`
fi
