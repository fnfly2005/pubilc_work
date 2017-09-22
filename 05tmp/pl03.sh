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

file="pl03"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with msg as (
		${msg}
		and (trackercode='item' or url='item')
		),
	 m1 as (
			select
				dt,
				regexp_extract(href,'pid=([v_0-9]+)',1) sku_code,
				count(distinct uuid) uv
			from
				msg
			group by
				1,2
		   ),
	 m2 as (
			 select
				sku_code,
				sum(uv) uv
			 from
				m1
			group by
				1
		   ),
	 sopd as (
			 ${sopd}
			 ),
	 ds as (
			 ${ds}
		   ),
	 s1 as (
			 select
				dt,
				category_lvl1_name,
				sku_code,
				prod_name,
				count(distinct babytree_enc_user_id) suv,
				sum(sku_num) sku_num,
				sum(order_amt) order_amt
			 from
				sopd
				join ds using(sku_id)
			group by
				1,2,3,4
		   ),
	 s2 as (
			 select
				category_lvl1_name,
				sku_code,
				max(prod_name) prod_name,
				sum(suv) suv,
				sum(sku_num) sku_num,
				sum(order_amt) order_amt
			 from
				s1
			group by
				1,2
		   ),
	s3 as (
			select
				category_lvl1_name,
				sku_code,
				prod_name,
				suv,
				sku_num,
				order_amt,
				row_number() over (order by order_amt desc) rank
			from
				s2
		  ),
	s4 as (
			select
				category_lvl1_name,
				sku_code,
				prod_name,
				suv,
				sku_num,
				order_amt,
				rank
			from
				s3
			where
				rank<=3000
		  ),
temp as (select 1)
	select
		category_lvl1_name,
		s4.sku_code,
		prod_name,
		sku_num,
		order_amt,
		rank,
		suv,
		uv
	from
		s4
		left join m2 on s4.sku_code=m2.sku_code
"|grep -iv "SET">${attach}
