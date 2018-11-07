#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
fut() {
	echo `grep -iv "\-time" ${path}sql/${1}.sql`
}
upi=`fun uc_point_info` 
up=`fut uc_point_info` 

file="nr01"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

if [ 2 = 1 ]
then
${presto_e}"
${se}
with upi as (
		${upi}
		),
temp as (select 1)
	select
		sum(point) point,
		sum(if(point>0,point,0)) point_in,
		sum(if(point<=0,point,0)) point_out
	from
		upi
"|grep -iv "SET"
#>${attach}
fi

if [ 1 = 1 ]
then
${presto_e}"
${se}
with upi as (
		${up}
		),
temp as (select 1)
			select
				sensitive_enc_user_id,
				sum(point) point
			from
				upi
			group by
				1
			having
				sum(point)>0
"|grep -iv "SET">${attach}
fi
