#!/bin/bash
clock=10
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
t3=`date -d "${t1% *} -1days ${clock}" +"%Y-%m-%d %T"`
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
dsa=`fun dim_single_activity`
dtt=`fun dim_topic_type`
dt=`fun dim_topic`
sopd=`fun sale_order_pay_detail`
ds=`fun dim_sku`

file="mh01"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with dsa as (
		${dsa}
		),
	 sopd as (
			 ${sopd}
			 ),
	 dt as (
			 ${dt}
		   ),
	 dtt as (
			 ${dtt}
			),
	 ds as (
			 ${ds}
		   ),
temp as (select 1)
	select
		case when parent_order_type=5 then '拼团'
		when dt.topic_id is null then '长期在线'
		when dsa.promotion_id is null then topic_type
		when topic_type='单品团' then dsa.topic_name
		else topic_type end,
		prod_name,
		sum(order_amt) order_amt
	from
		sopd
		join ds using(sku_id)
		left join dsa on sopd.promotion_id=dsa.promotion_id
		left join dt on dt.topic_id=sopd.topic_id
		left join dtt on dt.topic_type_id=dtt.topic_type_id
	group by
		1,2
"|grep -iv "SET">${attach}
