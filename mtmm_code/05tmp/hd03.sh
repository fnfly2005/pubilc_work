#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
ds=`fun dim_sku`
sopd=`fun sale_order_pay_detail`
tp="tmp.t_171027"

file="hd03"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with dst as (
		${ds}
		),
ds as (
		select
			dst.*
		from
			dst
			join ${tp} using(sku_code)
	  ),
sopd as (
		${sopd}
		),
temp as (select 1)
select
	dt,
	sku_code,
	count(distinct sensitive_enc_user_id) sensitive_enc_user,
	count(distinct parent_order_id) parent_order,
	sum(sku_num) sku_num,
	sum(order_amt) order_amt,
	sum(order_net_amt) order_net_amt
from
	ds join sopd using(sku_id)
group by
	1,2
"|grep -iv "SET">${attach}
