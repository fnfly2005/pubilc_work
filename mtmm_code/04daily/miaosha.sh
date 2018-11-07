#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
msg=`fun m_sourceubtpageview_gz` 

file="miaosha"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

model=${attach/00output/model}
cp ${model} ${attach}

${presto_e}"
${se}
with msg as (
		${msg}
		and trackercode like 'miaosha_viewpager_%'
		),
temp as (select 1)
			 select
				dt,
				trackercode,
				count(1) pv,
				count(distinct uuid) uv
			 from
				msg
			group by
				1,2
"|grep -iv "SET">>${attach}

name=(
		zhaohong
		zhouweixing
	 )
script="${path}bin/mail.sh"
topic="﻿秒杀流量日报"
content="﻿数据从${t1% *} 0点至${t2% *} 0点，邮件由系统发出，有问题请联系樊年"
address="fannian@sensitivemama.com"
for i in "${name[@]}"
do 
	address="${address}, ${i}@sensitivemama.com"
done

bash ${script} "${topic}" "${content}" "${attach}" "${address}"
