#!/bin/bash
source $public_home/base_code/etl/etl_fuc.sh

if [[ ${1}r == 'hr' ]];then
    echo "参数1为执行SQL文件,参数2为密码"
else
    mysqle $1 $2
fi
