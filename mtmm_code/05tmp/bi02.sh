#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
ci=`fun comment_item`
ds=`fun dim_sku`

file="bi02"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with ci as (
		${ci}
		),
	 ds as (
			 ${ds}
			 and category_lvl1_name='纸尿裤'
		   ),
temp as (select 1)
select
	mark,
	service_mark,
	transport_mark,
	count(comment_id) comment,
	avg(length(content)) content
from
	ci
	join ds using(sku_id)
group by
	1,2,3
"|grep -iv "SET">${attach}
