#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
msg=`fun m_sourceubtpageview_gz` 

file="pl01"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with m1 as (
		${msg}
		and (trackercode='special' or url='special')
		and sourcetype in ('btm-android','android')
		and (case when url='web' then split_part(split_part(split_part(href,'sid=',2),'&',1),'-',1) else split_part(href,'=',2) end)='128751'
		),
	 m2 as (
			 ${msg}
		and url='special'
		and sourcetype in ('btm-ios','ios')
		and split_part(href,'=',2)='128751'
		   ),
	 m as (
	select 
		referrer,
		uuid
	from
		m1
	union all
	select
		trackercode referrer,
		uuid
	from
		m2
		  ),
temp as (select 1)
	select
		referrer,
		count(1) pv,
		count(distinct uuid) uv
	from
		m
	group by
		1
"|grep -iv "SET">${attach}

