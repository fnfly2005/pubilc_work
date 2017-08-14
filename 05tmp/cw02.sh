#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fut() {
	echo `grep -iv "\-time" ${path}sql/${1}.sql`
}
sso=`fut sale_sub_order` 
dbu=`fut dim_biz_unit`
dst=`fut dim_sea_type`

file="cw02"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

if [ 1 = 2 ]
then
${presto_e}"
${se}
with sso as (
		${sso}
		delivered_time is not null
		and done_time is not null
		and (substr(delivered_time,1,4)='2017'
			or substr(done_time,1,4)='2017')
		),
	 dbu as (
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
				sso
			where
				substr(delivered_time,1,4)='2017'
			group by
				1,2,3
			),
	 sd as (
			 select
				substr(done_time,1,7) mt,
				sea_type_id,
				biz_unit_id,
				sum(order_amt) shouhuo_order_amt
			 from
				sso
			where
				substr(done_time,1,4)='2017'
			group by
				1,2,3
			),
temp as (select 1)
	select
		sd.mt,
		sea_type_name,
		biz_unit_name,
		fahuo_order_amt,
		shouhuo_order_amt
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
with sso as (
		${sso}
		delivered_time is not null
		and done_time is not null
		and (substr(delivered_time,1,4)='2017'
			and substr(done_time,1,4)='2017')
		),
	 s1 as (
			 select
				substr(delivered_time,1,10) delivered_time,
				substr(done_time,1,10) done_time
			 from
				sso
		   ),
temp as (select 1)
	select
		avg(date_diff('day',date_parse(delivered_time,'%Y-%m-%d'),date_parse(done_time,'%Y-%m-%d')))
	from
		s1
	where
		date_diff('day',date_parse(delivered_time,'%Y-%m-%d'),date_parse(done_time,'%Y-%m-%d'))>0
"
