#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
ci=`fun comment_item` 

file="sg03"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with ci as (
		${ci}
		),
	 cm as (
			select
				substr(dt,1,7) mt,
				supplier_id,
				babytree_enc_user_id,
				comment_id,
				row_number() over(partition by 
					substr(dt,1,7),
					supplier_id,
					babytree_enc_user_id,
					order by comment_id) rank
			from
				ci
			),
	 c as (
		select
			babytree_enc_user_id,
			sum(comment) sum_ct,
			round(avg(comment),0) avg_ct
		from
			cm
		group by
			1
		  ),
temp as (select 1)
	select
		case when avg_ct<4 then 'u3'
		else 'o3' end type,
		sum(avg_ct) user
	from
		c
	group by
		1
"|grep -iv "SET"
#>${attach}
