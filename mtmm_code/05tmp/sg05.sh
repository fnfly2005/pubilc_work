#!/bin/bash
clock=10
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
t3=`date -d "${t1% *} -30days ${clock}" +"%Y-%m-%d %T"`
t4=`date -d "${t1% *} -1months ${clock}" +"%Y-%m"`
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
ds=`fun dim_supplier` 
ssd=`fun seller_store_dsr`
sopd=`fun sale_order_pay_detail ${t3% *}`
ci=`fun comment_item ${t3% *}`
rsm=`fun rpt_supplier_manage_list_new_m ${t4}`

file="sg05"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

model=${attach/00output/model}
cp ${model} ${attach}

${presto_e}"
${se}
with ds as (
		${ds}
		),
	 ssd as (
			 ${ssd}
			),
	 sopd as (
			 ${sopd}
			 ),
	 ci as (
			 ${ci}
		   ),
	 rsm as (
			 ${rsm}
			),
	 dsd as (
			select
				'${t1% *}' dt,
				ssd.supplier_id,
				supplier_name,
				product_degree,
				service_degree,
				logistics_degree
			from
				ssd
				join ds using(supplier_id)
			union all
			select
				'${t1% *}' dt,
				-99 supplier_id,
				'all' supplier_name,
				product_degree,
				service_degree,
				logistics_degree
			from
				rsm
			),
	 s1 as (
			 select
				'${t1% *}' dt,
				supplier_id,
				count(distinct sub_order_id) so
			 from
				sopd
			group by
				1,2
			union all 
			select
				'${t1% *}' dt,
				-99 supplier_id,
				count(distinct sub_order_id) so	
			 from
				sopd
		   ),
	 c1 as (
			 select
				'${t1% *}' dt,
				supplier_id,
				count(distinct sub_order_id) co	
			 from
				ci
			group by
				1,2
			union all 
			select
				'${t1% *}' dt,
				-99 supplier_id,
				count(distinct sub_order_id) co	
			 from
				ci
		   ),
temp as (select 1)
	select
		dsd.*,
		case when co is null then 0 else co end co,
		case when so is null then 0 else so end so
	from
		dsd
		left join c1 on dsd.dt=c1.dt and dsd.supplier_id=c1.supplier_id
		left join s1 on dsd.dt=s1.dt and dsd.supplier_id=s1.supplier_id
"|grep -iv "SET">>${attach}

script="${path}bin/mail.sh"
topic="﻿评价日报"
content="﻿数据从${t1% *} 0点至${t2% *} 0点，邮件由系统发出，有问题请联系樊年"
address="fannian@sensitivemama.com"
mt_name=(
		jitiandong
		duyanhua
	 )
bb_name=(
	)
for i in "${mt_name[@]}"
do 
	address="${address}, ${i}@sensitivemama.com"
done
for i in "${bb_name[@]}"
do 
	address="${address}, ${i}@sensitive-inc.com"
done
bash ${script} "${topic}" "${content}" "${attach}" "${address}"
