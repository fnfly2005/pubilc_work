#!/bin/bash
if [[ $1 = 'h' ]];then
echo "参数1为数据库名 参数2位执行SQL文件 参数3为密码"
exit 0
fi
mysql -ufannian -D$1 < $2 -p$3
