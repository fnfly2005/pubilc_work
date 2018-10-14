#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
msg=`fun m_sourceubtpageview_gz` 
sopd=`fun sale_order_pay_detail`
ds=`fun dim_sku`

file="pl04"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with msg as (
		${msg}
		and (trackercode='item' or url='item')
		),
	 ds as (
			 ${ds}
		   ),
	 m1 as (
			select
				dt,
				regexp_extract(href,'pid=([v_0-9]+)',1) sku_code,
				uuid
			from
				msg
		   ),
	 m2 as (
			 select
				dt,
				supplier_name,
				brand_name,
				category_lvl1_name,
				category_lvl2_name,
				count(distinct uuid) uv
			 from
				m1
				join ds using(sku_code)
			group by
				1,2,3,4,5
		   ),
	 m3 as (
			 select
				supplier_name,
				brand_name,
				category_lvl1_name,
				category_lvl2_name,
				sum(uv) uv
			 from
				m2
			group by
				1,2,3,4
		   ),
	 sopd as (
			 ${sopd}
			 ),
	 s1 as (
			 select
				dt,
				supplier_name,
				brand_name,
				category_lvl1_name,
				category_lvl2_name,
				count(distinct babytree_enc_user_id) suv,
				sum(sku_num) sku_num,
				sum(order_amt) order_amt
			 from
				sopd
				join ds using(sku_id)
			group by
				1,2,3,4,5
		   ),
	 s2 as (
			 select
				supplier_name,
				brand_name,
				category_lvl1_name,
				category_lvl2_name,
				sum(suv) suv,
				sum(sku_num) sku_num,
				sum(order_amt) order_amt
			 from
				s1
			group by
				1,2,3,4
		   ),
temp as (select 1)
	select
		s2.supplier_name,
		s2.brand_name,
		s2.category_lvl1_name,
		s2.category_lvl2_name,
		sku_num,
		order_amt,
		suv,
		uv
	from
		s2
		left join m3 on s2.supplier_name=m3.supplier_name
		and s2.brand_name=m3.brand_name 
		and s2.category_lvl1_name=m3.category_lvl1_name
		and s2.category_lvl2_name=m3.category_lvl2_name
"|grep -iv "SET">${attach}
