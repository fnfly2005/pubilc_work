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
sopd=`fun sale_order_pay_detail` 
dp=`fun dim_province`
db=`fun dim_brand`
bd="(9640,9549,9571)"

file="cm06"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with sopd as (
		${sopd}
		),
	 s1 as (
			 select
				brand_id,
				babytree_enc_user_id,
				parent_order_id,
				province_id,
				pay_pregnant_month
			 from
				sopd
			where
				brand_id in ${bd}
			group by
				1,2,3,4,5
		   ),
	 db as (
			 ${db}
		   ),
	 s2 as (
			 select
				s1.brand_id,
				db.brand_name,
				count(distinct s1.babytree_enc_user_id) sv
			 from
				sopd
				join s1 using(babytree_enc_user_id)
				join db on sopd.brand_id=db.brand_id
			where
				sopd.brand_id<>s1.brand_id 
			group by
				1,2
		   ),
	 dp as (
		${dp}
		),
	 s3 as (
			 select
				brand_id,
				province_name,
				count(distinct babytree_enc_user_id) sv
			 from
				s1
				join dp using(province_id)
			group by
				1,2
		   ),
	 s4 as (
			 select
				brand_id,
				pay_pregnant_month,
				count(distinct babytree_enc_user_id) sv
			 from
				s1
			group by
				1,2
		   ),
	 s5 as (
			 select
				brand_id,
				count(distinct babytree_enc_user_id) sv
			 from
				s1
			group by
				1
		   ),
	 s6 as (
			 select
				brand_id,
				babytree_enc_user_id
			 from
				s1
			group by
				1,2
			having
				count(distinct parent_order_id)>1
		   ),
	 s7 as (
			 select
				brand_id,
				count(babytree_enc_user_id) sv
			 from
				s6
			group by
				1
		   ),
temp as (select 1)
	select
		brand_id,
		brand_name t,
		sv
	from
		s2
	union all
	select
		brand_id,
		province_name t,
		sv
	from
		s3
	union all
	select
		brand_id,
		pay_pregnant_month t,
		sv
	from
		s4
	union all
	select
		brand_id,
		'allsv' t,
		sv
	from
	    s5
	union all
	select
		brand_id,
		'fugousv' t,
		sv
	from
	    s7
"|grep -iv "SET">${attach}
