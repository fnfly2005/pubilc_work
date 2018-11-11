#!/usr/bin/bash
#批量替换工具
helpinfo="批量替换工具——参数1为模式选择,参数2为原字符,参数3为新字符
当参数1=p时,参数4为路径
当参数1=s时,参数4为文件"

case $1 in
    h) echo $helpinfo ;;
    p) LC_CTYPE=C sed -i '' 's/'$2'/'$3'/g' `grep $2 -rl $4`;;
    s) LC_CTYPE=C sed -i 's/'$2'/'$3'/g' $4;;
esac
