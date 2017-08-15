#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
sri=`fun so_reject_info` 
ssi=`fun seller_store_info`
sri=`fun so_reject_issue`

file="kf02"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with as (
		${}
		),
temp as (select 1)
"|grep -iv "SET">${attach}

model=${attach/00output/model}
cp ${model} ${attach}

name=(
	fannian
	 )
script="${path}bin/mail.sh"
topic="﻿${file}数据报表"
content="﻿数据从${t1% *} 0点至${t2% *} 0点，邮件由系统发出，有问题请联系樊年"
address="fannian@meitunmama.com"
for i in "${name[@]}"
do 
	address="${address}, ${i}@meitunmama.com"
done
bash ${script} "${topic}" "${content}" "${attach}" "${address}"
