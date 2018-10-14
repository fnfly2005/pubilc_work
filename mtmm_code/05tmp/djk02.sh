#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
msg=`fun m_sourceubtpageview_gz` 
dmsg=`fun djk_m_sourceubtpageview_gz`

file="djk02"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with msg as (
		${msg}
		and sourcetype in ('btm-android', 'btm-ios')
		),
	 dmsg as (
			 ${dmsg}
			 ),
	 m as (
			 select
				'${t1% *}' dt,
				count(distinct uuid) mt_uv
			 from
				msg
			group by
				1
		  ),
	 d as (
			 select
				'${t1% *}' dt,
				count(distinct uuid) djk_uv
			 from
				dmsg
			group by
				1
		  ),
	 dm as (
			 select
				'${t1% *}' dt,
				count(distinct msg.uuid) jo_uv
			 from
				msg
				join dmsg on msg.uuid=dmsg.uuid 
					and msg.sourcetype=dmsg.sourcetype
		   ),
temp as (select 1)
	select
		'${t1% *}' dt,
		mt_uv,
		djk_uv,
		jo_uv
	from
		m,d,dm
"|grep -iv "SET">>${attach}
