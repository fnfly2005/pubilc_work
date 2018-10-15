#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
sc=`fun sp_contract 2017-03-01` 
ds=`fun dim_sku`
sopd=`fun sale_order_pay_detail`

file="sg01"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with sc as (
		${sc}
		),
	 ds as (
			 ${ds}
			 and biz_unit=2
		   ),
	 sd as (
		select distinct
			ds.supplier_id,
			supplier_name,
			sea_type
		from
			sc join ds using(supplier_id)
		   ),
	 sopd as (
			 ${sopd}
			 ),
temp as (select 1)
	select
		sd.supplier_id,
		supplier_name,
		sd.sea_type,
		case when sopd.supplier_id is null then '连续无销售'
		else substr(dt,1,7) end mt,
		sum(case when sopd.supplier_id is null then 0 
				else order_amt end) order_amt
	from
		sd
		left join sopd using(supplier_id)
	group by
		1,2,3,4	
"|grep -iv "SET">${attach}
