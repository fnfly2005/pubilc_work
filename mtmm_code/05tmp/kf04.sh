#!/bin/bash
clock=10
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
t3=`date -d "${t1% *} -1days ${clock}" +"%Y-%m-%d %T"`
path="/data/fannian/"
fut() {
	echo `grep -iv "\-time" ${path}sql/${1}.sql`
}
sso=`fut sale_sub_order` 

file="kf04"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

model=${attach/00output/model}
cp ${model} ${attach}

${presto_e}"
${se}
with sso as (
		${sso}
		dt>='${t1% *}'
		and dt<'${t2% *}'
		),
temp as (select 1)
	select
		dt,
		count(distinct parent_order_id)
	from
		sso
	group by
		1
	order by
		1
"|grep -iv "SET">>${attach}


script="${path}bin/mail.sh"
topic="﻿订单日报"
content="﻿数据从${t1% *} 0点至${t2% *} 0点，邮件由系统发出，有问题请联系樊年"
address="fannian@meitunmama.com"
mt_name=(
		xiongdandan
		duyanhua
	 )
bb_name=(
	)
for i in "${mt_name[@]}"
do 
	address="${address}, ${i}@meitunmama.com"
done
for i in "${bb_name[@]}"
do 
	address="${address}, ${i}@babytree-inc.com"
done
bash ${script} "${topic}" "${content}" "${attach}" "${address}"
