#!/bin/bash
#git 提交工具
if [[ $1 = h ]];then
    echo "参数1为提交文件，参数2为提交描述"
else
    git add $1
    git commit -m "$2" $1
fi
