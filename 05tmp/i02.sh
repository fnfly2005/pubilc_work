#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
ci=`fun comment_item` 
sopd=`fun sale_order_pay_detail`

file="i02"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with ci as (
		${ci}
		),
	 sopd as (
			 ${sopd}
			 ),
	 s1 as (
			 select
				babytree_enc_user_id,
				max(dt) dt
			 from
				sopd
			group by
				1
		   ),
	 cs as (
			 select distinct
				sopd.dt,
				mark,
				service_mark,
				transport_mark,
				sopd.babytree_enc_user_id
			 from
				ci
				join sopd on ci.babytree_enc_user_id=sopd.babytree_enc_user_id
				and ci.sub_order_id=sopd.sub_order_id
		   ),
temp as (select 1)
	select
		mark,
		service_mark,
		transport_mark,
		case when s1.babytree_enc_user_id is not null then 0
		else 1 end isfugou,
		count(distinct cs.babytree_enc_user_id) cuv
	from
		cs
		left join s1 on cs.babytree_enc_user_id=s1.babytree_enc_user_id
		and cs.dt=s1.dt
	group by
		1,2,3,4
"|grep -iv "SET">${attach}
