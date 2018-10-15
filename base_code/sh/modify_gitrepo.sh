#!/bin/bash
#批量修改git仓库提交人
for i in `seq 1 $1`
do
    git commit --amend --author "fnfly2005 <fnfly2005@aliyun.com>"
    git rebase --continue
done
