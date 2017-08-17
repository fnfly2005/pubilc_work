#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}

path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
sri=`fun so_reject_info`
sso=`fun sale_sub_order`
sopd=`fun sale_order_pay_detail`
ds=`fun dim_sku`

file="cp01"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

if [ 2 = 1 ]
then
${presto_e}"
${se}
with sri as (
		${sri}
		and reject_type=0
		and reject_status=3
		),
	 sso as (
			 ${sso}
			),
	 s1 as (
			select
				dt,
				count(distinct sub_order_id) all_so,
				count(distinct case when pay_time is not null 
						then sub_order_id end) sale_so,
				count(distinct case when order_status=0 
						then sub_order_id end) cancel_so,
				count(distinct case when sri.sub_order_code is not null 
						then sub_order_id end) reject_so
			from
				sso
				left join sri using(sub_order_code)
			group by
				1
		   ),
	 s2 as (
			select
				substr(dt,1,7) mt,
				sum(all_so) all_so,
				avg(sale_so) avg_sale_so,
				sum(sale_so) sale_so,
				sum(cancel_so) cancel_so,
				sum(reject_so) reject_so
			from
				s1
			group by
				1
		   ),
temp as (select 1)
	select
		avg(all_so) all_so,
		avg(avg_sale_so) avg_sale_so,
		avg(sale_so) sale_so,
		avg(cancel_so) cancel_so,
		avg(reject_so) reject_so
	from
		s2
"|grep -iv "SET"
fi

if [ 1 = 1 ]
then
${presto_e}"
${se}
with sopd as (
		${sopd}
		),
	 ds as (
			 ${ds}
		   ),
	 sd as (
			select
				substr(dt,1,7) mt,
				sopd.supplier_id,
				count(distinct sub_order_id) so,
				count(distinct sku_code) sc
			from
				sopd join ds using(sku_id)
			group by
				1,2
		   ),
temp as (select 1)
	select
		supplier_id,
		avg(so) so,
		avg(sc) sc
	from
		sd
	group by
		1
"|grep -iv "SET">${attach}
fi
