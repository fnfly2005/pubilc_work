#!/bin/bash
t1=${1:-`date -d "yesterday -6days ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 7days ${clock}" +"%Y-%m-%d %T"`}
t3=`date -d "${t1% *} -1days ${clock}" +"%Y-%m-%d %T"`
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
msg=`fun m_sourceubtpageview_gz` 
sso=`fun sale_sub_order`

file="kf03"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

model=${attach/00output/model}
cp ${model} ${attach}

if [ 1 = 2 ]
then
${presto_e}"
${se}
with msg as (
		${msg}
		),
	 sso as (
			 ${sso}
			),
temp as (select 1)
	select
		dt,
		sourcetype,
		regexp_extract(href,'kefucode=([0-9]+)',1) shopid,
		trackercode,
		count(1) pv,
		count(distinct uuid) uv,
		'seller' type
	from
		msg
	where
		trackercode in ('item_kefu','h5stpage_kefu','tem_kefu','MyMeiTun_MessageCenter','MessageCenter_MessageList')
	group by
		1,2,3,4
	union all
	select
		msg.dt,
		sourcetype,
		cast(supplier_id as varchar) shopid,
		trackercode,
		count(1) pv,
		count(distinct uuid) uv,
		'order_detail' type
	from
		msg join sso on 
		regexp_extract(href,'orderid=([0-9]+)',1)=cast(sub_order_id as varchar)
		and trackercode='order_item_kefu'
	group by
		1,2,3,4
	union all
	select
		dt,
		sourcetype,
		'none' shopid,
		trackercode,
		count(1) pv,
		count(distinct uuid) uv,
		'kfzx' type
	from
		msg
	where
		trackercode in ('wentifl_bottom_rgkf','wentixq_bottom_rgkf')
		or trackercode like 'kfzx%'
		or trackercode like 'wentixq_@%'
	group by
		1,2,3,4
"|grep -iv "SET">>${attach}
fi

script="${path}bin/mail.sh"
topic="﻿客服数据周报"
content="﻿数据从${t1% *} 0点至${t2% *} 0点，邮件由系统发出，有问题请联系樊年"
address="fannian@meitunmama.com"
mt_name=(
		xiongdandan
		shenyingfei
		zhanggang
		duyanhua
	 )
bb_name=(
	)
for i in "${mt_name[@]}"
do 
	address="${address}, ${i}@meitunmama.com"
done
for i in "${bb_name[@]}"
do 
	address="${address}, ${i}@babytree-inc.com"
done
#bash ${script} "${topic}" "${content}" "${attach}" "${address}"
