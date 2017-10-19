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

file="bi05"
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
			and category_lvl1_name='纸尿裤'
		  ),
temp as (select 1)
	select
		category_lvl2_name,
		category_lvl3_name,
		count(distinct babytree_enc_user_id) babytree_enc_user_id,
		count(distinct parent_order_id) parent_order,
		sum(sku_num) sku_num,
		sum(order_amt) order_amt
	from
		sopd
		join ds using(sku_id)
	group by
		1,2
	union all
	select
		'all' category_lvl2_name,
		'all' category_lvl3_name,
		count(distinct babytree_enc_user_id) babytree_enc_user_id,
		count(distinct parent_order_id) parent_order,
		sum(sku_num) sku_num,
		sum(order_amt) order_amt
	from
		sopd
		join ds using(sku_id)
	group by
		1,2
"|grep -iv "SET">${attach}
