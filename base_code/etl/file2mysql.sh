#!/bin/bash
#导入csv至mysql
source $public_home/base_code/etl/etl_fuc.sh

if [[ ${1}r == 'hr' ]];then
    echo "导入csv至mysql 参数1为导入文件,参数2为密码,注意文件名应与表名一致"
else
    mysqll $1 $2
fi
