#!/bin/bash
t1=${1:-`date -d "yesterday -5days" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
sosd=`fun seller_order_send_data` 
ds=`fun dim_sku`

file="sg04"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

model=${attach/00output/model}
cp ${model} ${attach}

${presto_e}"
${se}
with sosd as (
		${sosd}
		and logistics_type in (2,3)
		),
	 ds as (
			 ${ds}
		   ),
	 d1 as (
			 select 
				supplier_id,
				max(supplier_name) supplier_name
			 from
				ds
			group by 
				1
		   ),
temp as (select 1)
	select
		dt,
		supplier_name,
		logistics_type,
		sub_order_num,
		upld_48hr_hour_num,
		upld_72hr_hour_num,
		exprss_72hour_num,
		exprss_120hour_num
	from
		sosd
		join d1 using(supplier_id)
"|grep -iv "SET">>${attach}

script="${path}bin/mail.sh"
topic="﻿海淘物流时效日报"
content="﻿数据从${t1% *} 0点至${t2% *} 0点，邮件由系统发出，有问题请联系樊年"
address="fannian@sensitivemama.com"
mt_name=(
		jitiandong
		zhaoyue2
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
