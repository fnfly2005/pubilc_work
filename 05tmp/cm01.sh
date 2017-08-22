#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
ds=`fun dim_sku`
sopd=`fun sale_order_pay_detail`

file="cm01"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with ds as (
		${ds}
		and category_lvl3_name in ('哈衣/连身衣','包屁衣','哈衣/连身衣/爬服','牙胶','牙胶/摇铃')
		),
sopd as (
		${sopd}
		),
temp as (select 1)
select
	substr(dt,1,7) mt,
	category_lvl3_name,
	sea_type,
	brand_name,
	spu_name,
	prod_name,
	sum(sku_num) sku_num,
	sum(order_amt) order_amt
from
	ds join sopd using(sku_id)
group by
	1,2,3,4,5,6
"|grep -iv "SET">${attach}
