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
temp as (select 1)
	select
		case when dt.topic_id is null then '长期在线'
		when dsa.promotion_id is null then topic_type
		else '单品团' end,
		sum(order_amt) order_amt
	from
		sopd
		left join dsa using(promotion_id)
		left join dt on dt.topic_id=sopd.topic_id
		left join dtt on dt.topic_type_id=dtt.topic_type_id
	group by
		1
"|grep -iv "SET"
#>${attach}

