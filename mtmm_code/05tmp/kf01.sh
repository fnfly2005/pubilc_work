#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
sri=`fun so_reject_info` 
ssi=`fun seller_store_info`

file="kf01"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with sri as (
		${sri}
		),
	 ssi as (
			 ${ssi}
			),
	 sai as (
	select
		substr(create_time,1,10) cdt,
		substr(cs_audit_time,1,10) adt,
		case audit_status
		when 2 then '待审核'
		when 5 then '商家审核通过'
		when 6 then '商家审核不通过'
		else '其他' end audit_status,
		reject_no
	from
		sri
		join ssi using(supplier_id)
			),
	 s1 as (
			 select
				cdt,
				audit_status,
				count(distinct reject_no) creject_no
			 from
				sai
			group by
				1,2
		   ),
	 s2 as (
			 select
				adt,
				audit_status,
				count(distinct reject_no) areject_no
			 from
				sai
			group by
				1,2
		   ),
	 s3 as (
	select
		cdt,
		s1.audit_status,
		creject_no,
		areject_no
	from
		s1
		join s2 on s1.cdt=s2.adt
		and s1.audit_status=s2.audit_status
		),
temp as (select 1)
	select
		*
	from
		s3
	union all
	select
		cdt,
		'所有' audit_status,
		sum(creject_no) creject_no,
		sum(areject_no) areject_no
	from
		s3
	group by
		1,2
"|grep -iv "SET">${attach}
