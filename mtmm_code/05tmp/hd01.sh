#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
msg=`fun m_sourceubtpageview_gz`
sopd=`fun sale_order_pay_detail` 
ds=`fun dim_sku`

if [ -z ${3} ]
then 
cms="http://m.sensitive.com/index.html?sid=863&title=海淘嘉年华&mtoapp=23"
else
cms="${3}"
fi

file="hd01"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

model=${attach/00output/model}
cp ${model} ${attach}

${presto_e}"
${se}
with msg as (
		${msg}
		and (url like '%${cms}%'
		or href like '%${cms}%')
		),
	 m1 as (
			 select distinct
				sensitive_enc_user_id
			 from
				msg
			where
				sensitive_enc_user_id is not null
		   ),
	 m2 as (
			 select
				'${t1% *}' dt,
				count(1) pv,
				count(distinct uuid) uv
			 from
				msg
			group by
				1
		   ),
	 spd as (
			 ${sopd}
			 and pay_time>='2017-07-24 10:00:00'
			 and pay_time<'2017-07-29 10:00:00'
			 ),
	 ds as (
			 ${ds}
			 and ds.sea_type_id=1
		   ),
	 sopd as (
			 select
				sensitive_enc_user_id,
				parent_order_id,
				sub_order_id,
				sku_num,
				order_amt,
				order_net_amt
			from
				spd
				join ds using(sku_id)
			 ),
	 sm as (
	select
		'${t1% *}' dt,
		count(distinct m1.sensitive_enc_user_id) sensitive_enc_user,
		count(distinct parent_order_id) parent_order,
		count(distinct sub_order_id) sub_order,
		sum(sku_num) sku_num,
		sum(order_amt) order_amt,
		sum(order_net_amt) order_net_amt
	from
		m1
		join sopd on m1.sensitive_enc_user_id=sopd.sensitive_enc_user_id
	group by
		1
			 ),
temp as (select 1)
	select
		'${cms}' cms,
		m2.dt,
		pv,
		uv,
		sensitive_enc_user,
		parent_order,
		sub_order,
		sku_num,
		order_amt,
		order_net_amt
	from
		sm join m2 using(dt)
"|grep -iv "SET">>${attach}

name=(
	qinrui
	 )
script="${path}bin/mail.sh"
topic="﻿${file}数据报表"
content="﻿数据从${t1% *} 0点至${t2% *} 0点，邮件由系统发出，有问题请联系樊年"
address="fannian@sensitivemama.com"
for i in "${name[@]}"
do 
	address="${address}, ${i}@sensitivemama.com"
done
bash ${script} "${topic}" "${content}" "${attach}" "${address}"
