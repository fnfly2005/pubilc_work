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
sc=`fun sp_contract` 
scp=`fun sp_contract_product`
ds=`fun dim_sku`

file="pl02"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with sc as (
		${sc}
		),
	 scp as (
			 ${scp}
			),
temp as (select 1)
	select distinct
		isseawashes,
		supplier_id,
		supplier_name,
		brand_id,
		brand_name
	from
		sc
		join scp using(contract_id)
"|grep -iv "SET">${attach}
