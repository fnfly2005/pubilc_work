#!/bin/bash
if [[ $1 = 'h' ]];then
    echo "参数1为执行SQL文件,参数2为密码,参数3为库名"
else
    mysql -ufnfly2005 -D${3-upload_table} < $1 -p$2
fi
