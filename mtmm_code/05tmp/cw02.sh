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
dbu=`fut dim_biz_unit`
dst=`fut dim_sea_type`
ske=`fun so_kuaidi100_express`

file="cw02"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"
tp="meitun_tmp.so_kuaidi100_qianshou_081501"
sp="meitun_tmp.so_sub_order_qianshou_081501"

if [ 2 = 1 ]
then
${presto_e}"
${se}
create table ${tp} as
${ske}
;
create table ${sp} as
with sso as (
		${sso}
		delivered_time is not null
		and delivered_time>='2016-09-01'
		and delivered_time<'2017-08-01'
		)
select
	substr(delivered_time,1,10) delivered_time,
	dt,
	sea_type_id,
	biz_unit_id,
	order_amt
from
	sso
	left join ${tp} using(sub_order_code)
where
	(dt is not null and dt>='2017-01-01')
	or (dt is null and delivered_time>='2017-01-01')
"
fi

if [ 1 = 1 ]
then
${presto_e}"
${se}
with dbu as (
			 ${dbu}
			),
	 dst as (
			 ${dst}
			),
	 sdl as (
			 select
				substr(delivered_time,1,7) mt,
				sea_type_id,
				biz_unit_id,
				sum(order_amt) fahuo_order_amt
			from
				${sp}
			group by
				1,2,3
			),
	 sd as (
			 select
				substr(dt,1,7) mt,
				sea_type_id,
				biz_unit_id,
				sum(order_amt) qianshou_order_amt
			 from
				${sp}
			where
				dt is not null
			group by
				1,2,3
			),
temp as (select 1)
	select
		sd.mt,
		sea_type_name,
		biz_unit_name,
		fahuo_order_amt,
		qianshou_order_amt
	from
		sdl
		join sd on sdl.mt=sd.mt 
		and sdl.sea_type_id=sd.sea_type_id
		and sdl.biz_unit_id=sd.biz_unit_id
		join dst on dst.sea_type_id=sd.sea_type_id
		join dbu on dbu.biz_unit_id=sd.biz_unit_id
"|grep -iv "SET">${attach}
fi

${presto_e}"
${se}
with s1 as (
		 select
			substr(delivered_time,1,10) delivered_time,
			dt
		 from
			${sp}
		   ),
temp as (select 1)
	select
		avg(date_diff('day',date_parse(delivered_time,'%Y-%m-%d'),date_parse(dt,'%Y-%m-%d')))
	from
		s1
	where
		date_diff('day',date_parse(delivered_time,'%Y-%m-%d'),date_parse(dt,'%Y-%m-%d'))>0
"|grep -iv "SET"
