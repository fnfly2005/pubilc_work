#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
fut() {
	echo `grep -iv "\-time" ${path}sql/${1}.sql`
}
sso=`fut sale_sub_order` 
ske=`fun so_kuaidi100_express`

di="(673,127,34,0,32,132,1277,799)"

file="wl03"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

if [ 1 = 1 ]
then
${presto_e}"
${se}
with sso as (
		${sso}
		order_status<>0
		and approve_time is not null
		and pay_time>='2017-09-01'
		and pay_time<'2017-10-01'
		and supplier_id in ${di}
		),
	 ske as (
			${ske}
			),
	 s1 as (
			select
				sso.dt,
				supplier_id,
				province_name,
				city_name,
				sub_order_id,
				substr(pay_time,1,10) pay_time,
				ske.dt qs_dt
			from
				sso
				left join ske using(sub_order_code)
		   ),
temp as (select 1)
	select
		dt,
		supplier_id,
		province_name,
		city_name,
		count(distinct sub_order_id) all_so,
		count(distinct case when qs_dt is not null then sub_order_id end) qianshan_so,
		avg(date_diff('day',date_parse(pay_time,'%Y-%m-%d'),date_parse(qs_dt,'%Y-%m-%d'))) avg_dt
	from
		s1
	group by
		1,2,3,4
	union all
	select
		'all' dt,
		supplier_id,
		province_name,
		city_name,
		count(distinct sub_order_id) all_so,
		count(distinct case when qs_dt is not null then sub_order_id end) qianshan_so,
		avg(date_diff('day',date_parse(pay_time,'%Y-%m-%d'),date_parse(qs_dt,'%Y-%m-%d'))) avg_dt
	from
		s1
	group by
		1,2,3,4
"|grep -iv "SET">${attach}
fi
