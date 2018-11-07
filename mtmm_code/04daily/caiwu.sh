#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
t3=`date -d "${t1% *} 1 days ago ${clock}" +"%Y-%m-%d %T"`
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
sopd=`fun sale_order_pay_detail` 
ds=`fun dim_sku`


file="caiwu"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"
model=${attach/00output/model}
cp ${model} ${attach}

${presto_e}"
${se}
with sopd as (
		${sopd}
		),
	 ds as (
			 ${ds}
		   ),
temp as (select 1)
	select
		ds.sea_type,
		ds.biz_unit,
		ds.category_lvl1_name,
		sum(sopd.order_amt) order_amt
	from
		sopd
		join ds using(sku_id)
	group by
		1,2,3
"|grep -iv "SET">>${attach}

name=(
	zhaoqi
	jinxin
	duyanhua
	tangxiaozhou
	fannian
	 )
script="${path}bin/mail.sh"
topic="﻿财务日报"
content="﻿数据从${t1% *} 0点至${t2% *} 0点，邮件由系统发出，有问题请联系樊年"
address="wangyu1@sensitive-inc.com"
#, xugaiyuan@sensitive-inc.com"
for i in "${name[@]}"
do 
	address="${address}, ${i}@sensitivemama.com"
done

bash ${script} "${topic}" "${content}" "${attach}" "${address}"
