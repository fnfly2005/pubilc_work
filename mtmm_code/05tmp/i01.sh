#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
msg=`fun m_sourceubtpageview_gz`
sopd=`fun sale_order_pay_detail`

file="i01"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with msg as (
		${msg}
		and (trackercode='classify'
		or url='classify')
		),
	 m1 as (
			 select distinct
				babytree_enc_user_id
			 from
				msg
			where
				babytree_enc_user_id is not null
		   ),
	 m2 as (
			 select
				'${t1% *}' dt,
				count(1) pv,
				count(distinct uuid) uv
			 from
				msg
			group by
				1
		   ),
	 sopd as (
			 ${sopd}
			 ),
	 s1 as (
			select
				'${t1% *}' dt,
				count(distinct sopd.babytree_enc_user_id) ouv,
				sum(order_amt) order_amt
			from
				m1
				join sopd using(babytree_enc_user_id)
			group by
				1
		   ),
temp as (select 1)
	select
		m2.dt,
		pv,
		uv,
		ouv,
		order_amt
	from
		m2
		join s1 using(dt)
"|grep -iv "SET">>${attach}
