#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
ci=`fun comment_item` 
cir=`fun com_item_review`
sopd=`fun sale_order_pay_detail`
ds=`fun dim_sku`

file="i02"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

if [ 1 = 2 ]
then
${presto_e}"
${se}
with ci as (
		${ci}
		),
	 sopd as (
			 ${sopd}
			 ),
	 s1 as (
			 select
				sensitive_enc_user_id,
				max(dt) dt
			 from
				sopd
			group by
				1
		   ),
	 cs as (
			 select distinct
				sopd.dt,
				mark,
				service_mark,
				transport_mark,
				sopd.sensitive_enc_user_id
			 from
				ci
				join sopd on ci.sub_order_id=sopd.sub_order_id
		   ),
temp as (select 1)
	select
		mark,
		service_mark,
		transport_mark,
		case when s1.sensitive_enc_user_id is not null then 0
		else 1 end isfugou,
		count(distinct cs.sensitive_enc_user_id) cuv
	from
		cs
		left join s1 on cs.sensitive_enc_user_id=s1.sensitive_enc_user_id
		and cs.dt=s1.dt
	group by
		1,2,3,4
"|grep -iv "SET">${attach}
fi

if [ 1 = 1 ]
then
${presto_e}"
${se}
with ci as (
		${ci}
		),
	 sopd as (
			 ${sopd}
			 ),
	 ds as (
			 ${ds}
		   ),
	 s1 as (
			 select
				sensitive_enc_user_id,
				count(distinct dt) sdt
			 from
				sopd
			group by
				1
		   ),
	 s2 as (
			 select
				spu_id,
				count(distinct case when sdt>1 then s1.sensitive_enc_user_id end) suv,
				count(distinct s1.sensitive_enc_user_id) uv
			 from
				s1
				join sopd using(sensitive_enc_user_id)
				join ds on ds.sku_id=sopd.sku_id
			group by
				1
		   ),
	 cs as (
			 select
				spu_id,
				ci.sensitive_enc_user_id
			 from
				ci
				join sopd using(sub_order_id)
				join ds on ds.sku_id=sopd.sku_id
		   ),
	 c1 as (
			 select
				spu_id,	
				count(distinct case when sdt>1 then cs.sensitive_enc_user_id end) csuv,
				count(distinct cs.sensitive_enc_user_id) cuv
			 from
				cs
				join s1 using(sensitive_enc_user_id)
			group by
				1
		   ),
temp as (select 1)
	select
		s2.spu_id,
		suv-csuv ucsuv,
		uv-cuv ucuv,
		csuv,
		cuv
	from
		s2
		join c1 using(spu_id)
"|grep -iv "SET">${attach}
fi
