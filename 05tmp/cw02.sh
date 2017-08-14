#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fut() {
	echo `grep -iv "\-time" ${path}sql/${1}.sql`
}
sso=`fut sale_sub_order` 

file="cw02"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with sso as (
		${sso}
		delivered_time is not null
		and done_time is not null
		and (substr(delivered_time,1,4)='2017'
			or substr(done_time,1,4)='2017')
		),
	 sdl as (
			 select
				substr(delivered_time,1,7) mt,
				sum(order_amt) fahuo_order_amt
			 from
				sso
			where
				substr(delivered_time,1,4)='2017'
			group by
				1
			),
	 sd as (
			 select
				substr(done_time,1,7) mt,
				sum(order_amt) shouhuo_order_amt
			 from
				sso
			where
				substr(done_time,1,4)='2017'
			group by
				1
			),
temp as (select 1)
	select
		sd.mt,
		fahuo_order_amt,
		shouhuo_order_amt
	from
		sdl
		join sd using(mt)
"|grep -iv "SET">${attach}
