#!/bin/bash
clock=10
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
dr=`fun discussionresponse` 
dp=`fun discussionphoto`
u=`fun user`

file="hd02"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"


model=${attach/00output/model}
cp ${model} ${attach}

${presto_e}"
${se}
with dr as (
		${dr}
		and discussion_id=${3}
		and create_ts>='${t1}'
		and create_ts<'${t2% *}'
		),
	 dp as (
			 ${dp}
		and discussion_id=${3}
		and substr(cast(floor as varchar),
			length(cast(floor as varchar)),1)='6'
		   ),
	 u as (
			 ${u}
		  ),
temp as (select 1)
select distinct
	u.sensitive_enc_user_id,
	u.nickname,
	dp.floor
from
	dp join dr using(response_id)
	join u on dr.sensitive_user_id=u.sensitive_user_id
"|grep -iv "SET">>${attach}

name=(
	xiamingyue
	luoyuanjun
	xiating
	 )
script="${path}bin/mail.sh"
topic="﻿社区活动数据"
content="﻿邮件由系统发出，uid需要去重,有问题请联系樊年"
address="fannian@sensitivemama.com"
for i in "${name[@]}"
do 
	address="${address}, ${i}@sensitivemama.com"
done

bash ${script} "${topic}" "${content}" "${attach}" "${address}"
