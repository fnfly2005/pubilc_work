#!/bin/bash
mysql_e="mysql -h10.50.50.61 -P3360 -ubiuser -pkOi9H-G3I;vvnVt4 -N -e"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

path="/data/fannian/"

t1=${1:-`date -d "yesterday" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago" +"%Y-%m-%d %T"`}
t3=`date -d "${t1% *} 1 days ago" +"%Y-%m-%d %T"`
t4=`date -d "${t1% *} 1 month ago" +"%Y-%m-%d"`
m_day=$(echo `cal` |awk '{print $NF}')
t_day=`date -d "${t1% *}" +"%d"`
l_day=`echo "scale=0;(${m_day}-${t_day})"|bc`
m=$((10#`date -d "${t1% *}" +"%m"`))
n_day=`date -d "${t1% *} -1 days ago" +"%d"`

fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
ms=`fun m_sourceubtpageview` 
sso=`fun so_sub_order`
sop=`fun so_order_promotion`
sopd=`fun sale_order_pay_detail ${t4} ${t1}` 

file="alluv"
attach="${path}00output/${file}.csv"
all_data="${path}02data/sales_10.txt"

model=${attach/00output/model}
cp ${model} ${attach}

uv=`${presto_e}"
${se}
with ms as (
		${ms}
		),
temp as (select 1)
select
	'alluv' sourcetype,
	count(1) pv,
	count(distinct uuid) uv
from
	ms
group by
	1
union all
select
	sourcetype,
	count(1) pv,
	count(distinct uuid) uv
from
	ms
group by
	1
"|grep -iv "SET"|tee -a ${attach}|
grep "alluv"|awk -F ',' '{print $3}'|sed 's/"//g'`
o1=`echo ${uv} |awk '{printf "%'"'"'18.0f\n",$0}'|sed 's/ //g'`

tp_data=`${mysql_e}"
select
	sum(so.order_amt) order_amt,
	sum(case when so.sea_type_id=1 then so.order_amt end) sea_order_amt,
	(1-sum(so.order_net_amt)/sum(so.order_amt)) all_discount,
	((select 
		sum(discount)
	 from
		(${sso}) sso 
		join (${sop}) sop using(sub_order_id)
		)/sum(so.order_amt)) meitun_discount
from
	(${sso}) so
"`

med_sales=`${presto_e}"
${se}
with sopd as (
		${sopd}
		),
	 s1 as (
	select
		dt,
		sum(order_amt) order_amt
	from
		sopd
	group by
		1
	),	
temp as (select 1)
	select
		approx_percentile(order_amt,0.5) order_amt
	from
		s1
"|grep -iv "SET"|sed 's/"//g'`

order_amt=`echo ${tp_data}|awk -F ' ' '{printf("%.0f",$1)}'`
o2=`echo ${order_amt}|awk '{printf "%'"'"'18.0f\n",$1}'|sed 's/ //g'`
sea_order_amt=`echo ${tp_data}|awk -F ' ' '{printf("%.0f",$2)}'`
o3=`echo ${sea_order_amt}|awk '{printf "%'"'"'18.0f\n",$1}'|sed 's/ //g'`
all_discount=`echo ${tp_data}|awk -F ' ' '{printf("%.2f",$3*100)}'`
meitun_discount=`echo ${tp_data}|awk -F ' ' '{printf("%.2f",$4*100)}'`
m_sales_b=`cat ${all_data}|awk -F ' ' '{print $1}'`

if [ -z ${3} ]
then
m_sales_a=`echo "scale=0;${m_sales_b}+${order_amt}"|bc`
else
m_sales_a=`echo "scale=0;${m_sales_b}"|bc`
fi
o4=`echo ${m_sales_a}|awk '{printf "%'"'"'18.0f\n",$1}'|sed 's/ //g'`
m_sales_t=`cat ${all_data}|awk -F ' ' '{print $2}'`
o5=`echo "scale=1;${m_sales_t}/100000000"|bc`

m_sales_r=`echo "scale=2;${m_sales_a}*100/${m_sales_t}"|bc`
runrate=`echo "scale=2;(${m_sales_a}+${med_sales}*${l_day})*100/${m_sales_t}"|bc`
m_sales_d=`echo "scale=0;${m_sales_t}-${m_sales_a}"|bc`
o6=`echo ${m_sales_d}|awk '{printf "%'"'"'18.0f\n",$1}'|sed 's/ //g'`

if [ "01" = ${n_day} ]
then
echo "0 "${m_sales_t} >${all_data}
else
echo ${m_sales_a}" "${m_sales_t} >${all_data}
d_sales_d=`echo "scale=0;${m_sales_d}/${l_day}/10000"|bc`
o7=`echo "，完成目标每天需要"${d_sales_d}"万"`
o8=`echo "，预期达成率runrate为"${runrate}"%"`
fi

script="${path}bin/mail.sh"
topic="${file}_data"
content="﻿数据从${t1% *} 0点至${t2% *} 0点，邮件由系统发出，有问题请联系樊年"
address="fannian@meitunmama.com"
bash ${script} "${topic}" "${content}" "${attach}" "${address}"
name=(
	#zhaoqi
	#duyanhua
	#tangzhipeng
	#wanglizhong
	 )
for i in "${name[@]}"
do 
	address="${address}, ${i}@meitunmama.com"
done
topic="﻿昨日速报"
content="﻿昨日流量${o1}，GMV${o2}元，其中海淘GMV${o3}元。整体折扣力度${all_discount}%，其中美囤优惠券折扣${meitun_discount}%，${m}月1日00点开始截止到今天上午00点GMV累计${o4}元 。离目标${o5}亿还差${o6}元${o7}。月累计达成率${m_sales_r}%${o8}。数据从${t1% *} 0点至${t2% *} 0点，邮件由系统发出，有问题请联系樊年"
bash ${script} "${topic}" "${content}" "" "${address}"
