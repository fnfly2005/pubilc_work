#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
w=`fun warehouse`
sso=`fun sale_sub_order`

file="sg02"
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
			 and sea_type_id=1
			 and biz_unit=2
			 and order_status<>0
			),
	 sss as (
			 select
				*
			 from
				sso
			where
				length(delivered_time)=19
				and length(approve_time)=14
				and length(express_time)=14
				and delivered_time is not null
				and approve_time is not null
				and express_time is not null
			),
	 sw as (
			select
				sub_order_id,
				supplier_id,
				supplier_name,
				warehouse_type,
				date_parse(delivered_time,'%Y-%m-%d %H:%i:%S') delivered_time,
				date_parse(approve_time,'%Y%m%d%H%i%S') approve_time,
				date_parse(express_time,'%Y%m%d%H%i%S') express_time
			from
				sss 
				left join w using(warehouse_id)
		   ),
	 s1 as (
			select
				sub_order_id,
				supplier_id,
				supplier_name,
				warehouse_type,
				date_diff('hour',approve_time,delivered_time) ad,
				date_diff('hour',approve_time,express_time) ae
			from
				sw
		   ),
	 s2 as (
			 select
				case 
					when warehouse_type='保税区' and ad<48 then sub_order_id
					when warehouse_type='境外直发' and ad<72 then sub_order_id
				end adsta,
				case 
					when warehouse_type='保税区' and ae<72 then sub_order_id
					when warehouse_type='境外直发' and ae<120 then sub_order_id
				end aesta,
				supplier_id,
				supplier_name,
				warehouse_type,
				sub_order_id
			 from
				s1
		   ),
temp as (select 1)
	select
		supplier_id,
		supplier_name,
		warehouse_type,
		count(distinct adsta) adsta_sub,
		count(distinct aesta) aesta_sub,
		count(distinct sub_order_id) all_sub
	from
		s2
	group by
		1,2,3
"|grep -iv "SET">${attach}
