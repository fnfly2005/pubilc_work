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
sopd=`fun sale_order_pay_detail` 
ds=`fun dim_sku`

file="cm05"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with sopd as (
		${sopd}
		),
	ds as (
			${ds}
		  ),
temp as (select 1)
	select
		case when sea_type_id=1 then '海淘'
		else '国内' end sea_type,
		category_lvl1_name,
		sum(sku_num) sku_num,
		sum(order_amt) order_amt
	from
		sopd
		join ds using(sku_id)
	group by
		1,2
"|grep -iv "SET">${attach}
