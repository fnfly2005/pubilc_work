#!/bin/bash
clock=0
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
t3=`date -d "${t2% *}" +"%Y%m%d%H%M%S"`
path="/data/fannian/"
fut() {
	echo `grep -iv "\-time" ${path}sql/${1}.sql`
}
w=`fut warehouse`
sso=`fut sale_sub_order`

file="wl02"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with w as (
		${w}
		),
	 sso as (
			 ${sso}
			 dt>='${t1% *}'
			 and dt<'${t2% *}'
			 and order_status<>0
			),
	 sss as (
			 select
				sso.supplier_id,
				supplier_name,
				warehouse_type,
				sea_type_id,
				sub_order_id,
				approve_time,
				case when delivered_time is null then '${t2}'
				else delivered_time end delivered_time,
				case when express_time is null then '${t3}'
				when length(express_time)<>14 then null
				else express_time end express_time
			 from
				sso
				join w using(warehouse_id)
			where
				approve_time is not null
			),
	 sw as (
			select
				supplier_id,
				supplier_name,
				warehouse_type,
				sea_type_id,
				sub_order_id,
				date_parse(approve_time,'%Y%m%d%H%i%S') approve_time,
				date_parse(delivered_time,'%Y-%m-%d %H:%i:%S') delivered_time,
				date_parse(express_time,'%Y%m%d%H%i%S') express_time
			from
				sss 
		   ),
	 s1 as (
			select
				supplier_id,
				supplier_name,
				warehouse_type,
				sea_type_id,
				sub_order_id,
				case when delivered_time is null then null 
				else date_diff('hour',approve_time,delivered_time) end ad,
				case when express_time is null then null 
				else date_diff('hour',approve_time,express_time) end ae
			from
				sw
		   ),
temp as (select 1)
	select
		'${t1% *}' dt,
		supplier_id,
		supplier_name,
		supplier_name,
		warehouse_type,
		count(distinct sub_order_id) all_sub,
		count(distinct case when ad<24 then sub_order_id end) ad24_sub,
		count(distinct case when ae<24 then sub_order_id end) ae24_sub,
		count(distinct case when ae<48 then sub_order_id end) ae48_sub,
		count(distinct case when ae<72 then sub_order_id end) ae72_sub,
		count(distinct case when ae>=72 then sub_order_id end) ae72o_sub,
		count(distinct case when ae is null or ad is null then sub_order_id end) aenull_sub
	from
		s1
	group by
		1,2,3,4
"|grep -iv "SET">>${attach}
