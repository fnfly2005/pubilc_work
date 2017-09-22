#!/bin/bash
clock=10
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
t3=`date -d "${t1% *} -1days ${clock}" +"%Y-%m-%d %T"`
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
ds=`fun dim_supplier` 
dsk=`fun dim_sku`

file="sg06"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with ds as (
		${ds}
		),
	 dsk as (
			 ${dsk}
			),
	 dk as (
			 select distinct
				supplier_id
			 from
				dsk
			where
				biz_unit='自营'
		   ),
temp as (select 1)
	select
		dt,
		ds.supplier_id,
		supplier_name
	from
		ds
		left join dk using(supplier_id)
	where
		dk.supplier_id is null
"|grep -iv "SET">${attach}
