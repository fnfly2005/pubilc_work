#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fut() {
	echo `grep -iv "\-time" ${path}sql/${1}.sql`
}
ui=`fut user_info`
dpd=`fut dim_pregnancy_day`

file="djk04"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

model=${attach/00output/model}
cp ${model} ${attach}

${presto_e}"
${se}
with ui as (
		${ui}
		province_name='北京'
		),
	p as (
		select
			case when babybirthday is null then -999999 
			else date_diff('day',timestamp'${t1% *}',babybirthday) end distance,
			sensitive_enc_user_id
		from
			ui
		),
	 p1 as (
			 select
				case when distance>2520 then 999999
					when distance<-645 and distance>-999999 then -2100
				else distance end distance,
				sensitive_enc_user_id
			 from
				p
		   ),
	dpd as (
			${dpd}
		where
			pregnancy_week like '孕%'
			and (regexp_like(pregnancy_week,'2[7-8]')=TRUE
			or regexp_like(pregnancy_week,'3[5-9]')=TRUE)
		   )
		select distinct
			pregnancy_week,
			sensitive_enc_user_id
		from
			p1
			join dpd using(distance)
"|grep -iv "SET">${attach}

script="${path}bin/mail.sh"
topic="﻿人群uid"
content="﻿数据从${t1% *} 0点至${t2% *} 0点，邮件由系统发出，有问题请联系樊年"
address="fannian@sensitivemama.com"
mt_name=(
	 )
bb_name=(
		miaozhen
	)
for i in "${mt_name[@]}"
do 
	address="${address}, ${i}@sensitivemama.com"
done
for i in "${bb_name[@]}"
do 
	address="${address}, ${i}@sensitive-inc.com"
done
bash ${script} "${topic}" "${content}" "${attach}" "${address}"
