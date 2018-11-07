#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
t3=`date -d "${t1% *} -30days ${clock}" +"%Y-%m-%d %T"`
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
fut() {
	echo `grep -iv "\-time" ${path}sql/${1}.sql`
}
ci=`fun comment_item` 
sso=`fun sale_sub_order`

file="sg03"
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
	 cm as (
			select
				substr(dt,1,7) mt,
				supplier_id,
				sensitive_enc_user_id,
				mark,
				service_mark,
				transport_mark,
				comment_id,
				row_number() over(partition by 
					substr(dt,1,7),
					supplier_id,
					sensitive_enc_user_id
					order by comment_id) rank
			from
				ci
			),
	 c as (
		select
			supplier_id,
			mark,
			service_mark,
			transport_mark,
			count(comment_id) number
		from
			cm
		where
			rank<=3
		group by
			1,2,3,4
		  ),
temp as (select 1)
	select
		supplier_id,
		sum(mark*number),
		sum(service_mark*number),
		sum(transport_mark*number),
		sum(number)
	from
		c
	group by
		1
"|grep -iv "SET">${attach}
fi

${presto_e}"
${se}
with ci as (
		${ci}
		),
	 c1 as (
			 select distinct
				date_parse(dt,'%Y-%m-%d') dt,
				sub_order_id
			 from
				ci
		   ),
	 sso as (
			 ${sso}
			),
	 s1 as (
			 select
				date_parse(substr(done_time,1,10),'%Y-%m-%d') done_time,
				date_parse(substr(delivered_time,1,10),'%Y-%m-%d') delivered_time,
				sub_order_id
			 from
				sso
			where
				done_time is not null
		   ),
temp as (select 1)
	select
		case when c1.sub_order_id is null then 0
		else 1 end iscom,
		count(1)
	from
		s1
		left join c1 using(sub_order_id)
	group by
		1
"|grep -iv "SET"
#>${attach}
