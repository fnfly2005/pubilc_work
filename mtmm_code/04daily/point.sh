#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
t3=`date -d "${t1% *} 1 days ago ${clock}" +"%Y-%m-%d %T"`
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
ds=`fun dim_sku`
pti=`fun pr_topic_item`
dsa=`fun dim_single_activity`
sopd=`fun sale_order_pay_detail`

file="point"
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
	 pti as (
			 ${pti}
			 and mt_subsidy_amount>0
			),
	 dsa as (
			 ${dsa}
			 and sale_pattern=16
			),
	 sopd as (
			 ${sopd}
			 ),
temp as (select 1)
select
	'${t1% *}' dt,
	sopd.topic_id,
	sopd.promotion_id,
	category_lvl1_name,
	barcode,
	count(distinct parent_order_id) parent_order,
	sum(sku_num) sku_num,
	sum(used_point) used_point,
	sum(mt_subsidy_amount) mt_subsidy_amount,
	sum(order_amt) order_amt
from
	sopd
	join dsa using(promotion_id)
	join ds on ds.sku_id=sopd.sku_id
	join pti on pti.sku_code=ds.sku_code and pti.topic_id=sopd.topic_id
group by
	1,2,3,4,5
"|grep -iv "SET">>${attach}

name=(
		wutingting
		wuxinyi
	 )
script="${path}bin/mail.sh"
topic="﻿积分商城日报"
content="﻿数据从${t1% *} 0点至${t2% *} 0点，邮件由系统发出，有问题请联系樊年"
address="fannian@sensitivemama.com"
for i in "${name[@]}"
do 
	address="${address}, ${i}@sensitivemama.com"
done

bash ${script} "${topic}" "${content}" "${attach}" "${address}"
