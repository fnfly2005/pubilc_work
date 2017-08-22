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

file="cm02"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with ds as (
		${ds}
		),
sopd as (
		${sopd}
		),
dss as (
select
	substr(dt,1,7) mt,
	category_lvl1_name,
	brand_name,
	prod_name,
	sum(sku_num) sku_num,
	sum(order_amt) order_amt
from
	ds join sopd using(sku_id)
group by
	1,2,3,4
	   ),
	d1 as (
	select
		*,
		'销售数量排序' rank_type,
		row_number() over (partition by mt order by sku_num desc) rank
	from
		dss
	union all
	select
		*,
		'销售金额排序' rank_type,
		row_number() over (partition by mt order by order_amt desc) rank
	from
		dss
		  ),
temp as (select 1)
	select
		*
	from
		d1
	where
		rank<=300
	order by
		rank_type,
		mt,
		rank
"|grep -iv "SET">${attach}
