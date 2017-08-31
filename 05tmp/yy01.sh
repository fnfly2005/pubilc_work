#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
ci=`fun comment_item` 

file="yy01"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with ci as (
		${ci}
		),
	 c as (
			select
				dt,
				count(distinct babytree_enc_user_id) cuv,
				count(comment_id) cnum
			from
				ci
			group by
				1
		  ),
temp as (select 1)
	select
		avg(cuv) cuv,
		avg(cnum) cnum
	from
		c
"|grep -iv "SET"
