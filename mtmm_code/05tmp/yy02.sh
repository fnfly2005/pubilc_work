#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
rpa=`fun rpt_pintuan_activity_sale_by_days` 
pab=`fun pr_activity_base`
pai=`fun pr_activity_item`
dsk=`fun dim_sku`
dsp=`fun dim_spu`

file="yy02"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

model=${attach/00output/model}
cp ${model} ${attach}

${presto_e}"
${se}
with rpa as (
		${rpa}
		),
	 pab as (
			 ${pab}
			),
	pai as (
			${pai}
		   ),
	dsk as (
			${dsk}
		   ),
	pd as (
			select
				promotion_id,
				biz_unit,
				avg(activity_price) activity_price
			from
				pai
				join dsk using(sku_code)
			group by
				1,2
		  ),
temp as (select 1)
	select
		rpa.*,
		start_time,
		end_time,
		date_diff('day',start_time,end_time) last_time,
		activity_price,
		biz_unit
	from
		rpa
		left join pab using(promotion_id)
		left join pd on pd.promotion_id=rpa.promotion_id
"|grep -iv "SET">>${attach}


script="${path}bin/mail.sh"
topic="﻿拼团数据日报"
content="﻿数据从${t1% *} 0点至${t2% *} 0点，邮件由系统发出，有问题请联系樊年"
address="fannian@sensitivemama.com"
mt_name=(
		meiya
		duyanhua
	 )
bb_name=(
		lijiaqing
		zhangjie
		baiyi
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
