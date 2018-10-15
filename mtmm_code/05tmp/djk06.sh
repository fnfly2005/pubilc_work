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
#ag=`fun appcontentclicklog_gz` 
dmsg=`fun djk_m_sourceubtpageview_gz ${t3% *}`

file="djk06"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"
tp="test.djk_js_uuid_fn_test"


${presto_e}"
${se}
with dmsg as (
		${dmsg}
		and regexp_like(trackercode,'djk_js_')
		and dt='${t1% *}'
		),
temp as (select 1)
	select
		'${t1% *}' dt,
		sourcetype,
		trackercode,
		count(distinct uuid) uv
	from
		dmsg
	where
		dt='${t1% *}'
	group by
		1,2,3
"|grep -iv "SET">>${attach}
