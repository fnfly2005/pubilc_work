#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
pab=`fun pr_activity_base` 
pai=`fun pr_activity_item`

file="pd01"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with pab as (
		${pab}
		),
	 pai as (
			 ${pai}
			),
temp as (select 1)
	select
		pab.promotion_id,
		topic_name,
		activity_price,
		start_time,
		end_time,
		date_diff('day',start_time,end_time) last_time
	from
		pab
		join pai using(promotion_id)
"|grep -iv "SET">${attach}

