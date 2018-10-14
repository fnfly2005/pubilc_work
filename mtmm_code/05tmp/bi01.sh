#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
ct=`fun comment_test` 
ci=`fun comment_item`
ds=`fun dim_sku`

file="bi01"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with ct as (
		${ct}
		),
	 ci as (
			 ${ci}
			 and mark=1
			 and service_mark=1
			 and transport_mark=1
		   ),
	 ds as (
			 ${ds}
			 and category_lvl1_name='纸尿裤'
		   ),
temp as (select 1)
select distinct
	key,
	content
from
	ci
	join ds using(sku_id)
	join ct on ci.comment_id=ct.comment_id
"|grep -iv "SET">${attach}
