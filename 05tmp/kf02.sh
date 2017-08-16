#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
t3=`date -d "${t1% *} -1days ${clock}" +"%Y-%m-%d %T"`
t4=`date -d "${t1% *} -30days" +"%Y-%m-%d"`

path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
sri=`fun so_reject_info ${t4}` 
ssi=`fun seller_store_info`
srs=`fun so_reject_issue`
sopd=`fun sale_order_pay_detail`

file="kf02"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

model=${attach/00output/model}
cp ${model} ${attach}

${presto_e}"
${se}
with sri as (
		${sri}
		),
	 ssi as (
			 ${ssi}
			),
	 srs as (
			 ${srs}
			 and status=20
			),
	 sopd as (
			 ${sopd}
			 ),
	 s1 as (
			 select
				'${t1% *}' dt,
				count(distinct sub_order_id) sub_order
			 from
				sopd
				join ssi using(supplier_id)
		   ),
	 s2 as (
			select
				'${t1% *}' dt,
				count(distinct order_no) jiufen_no
			from
				sri join ssi using(supplier_id)
				join srs on sri.reject_no=srs.reject_no
		   ),
	 s3 as (
			 select
				'${t1% *}' dt,
				count(distinct order_no) no_48
			 from
				sri join ssi using(supplier_id)
			where
				create_time>='${t3% *}'
		   ),
	 s4 as (
			 select
				'${t1% *}' dt,
				count(distinct order_no) no_24
			 from
				sri join ssi using(supplier_id)
			where
				create_time>='${t1% *}'
		   ),
temp as (select 1)
	select
		s1.dt,
		jiufen_no,
		sub_order,
		no_24,
		no_48
	from
		s1 
		join s2 on s1.dt=s2.dt
		join s3 on s1.dt=s3.dt
		join s4 on s1.dt=s4.dt
"|grep -iv "SET">>${attach}


name=(
	zhanggang
	duyanhua
	 )
script="${path}bin/mail.sh"
topic="﻿仲裁数据日报"
content="﻿数据从${t1% *} 0点至${t2% *} 0点，邮件由系统发出，有问题请联系樊年"
address="fannian@meitunmama.com"
for i in "${name[@]}"
do 
	address="${address}, ${i}@meitunmama.com"
done
bash ${script} "${topic}" "${content}" "${attach}" "${address}"
