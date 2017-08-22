#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
msg=`fun m_sourceubtpageview_gz` 

file="cm03"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with msg as (
		${msg}
		and (trackercode='item' or url='item')
		and regexp_extract(href,'pid=([v_0-9]+)',1)='03180300210101'
		),
temp as (select 1)
select
	dt,
	count(1) pv,
	count(distinct uuid) uv
from
	msg
group by
	1
"|grep -iv "SET">${attach}

