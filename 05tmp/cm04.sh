#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
ui=`fun user_info`
upf=`fun user_profile_full`
dldm=`fun dim_location_district_match`
hd=`fun hier_district`
dc=`fun dim_city`
ytp="meitun_tmp.fannian_user_info_0825_3"
mtp="meitun_tmp.fannian_user_profile_full_0825_3"

file="cm04"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

if [ 1 = 1 ]
then
${presto_e}"
${se}
create table ${ytp} as
	${ui};
create table ${mtp} as
	${upf};
"
fi

if [ 1 = 2 ]
then
${presto_e}"
${se}
select
	y.province_name,
	approx_distinct(y.babytree_enc_user_id)
from
	${ytp} y
	join ${mtp} u using(babytree_enc_user_id)
group by
	1
"|grep -iv "SET">${attach}
fi

${presto_e}"
${se}
select
	pregnancy_month,
	approx_distinct(y.babytree_enc_user_id)
from
	${ytp} y
	join ${mtp} u using(babytree_enc_user_id)
group by
	1
"|grep -iv "SET">${attach}

if [ 1 = 2 ]
then
${presto_e}"
${se}
with dldm as (
		${dldm}
		),
	 hd as (
			 ${hd}
		   ),
	 dc as (
			 ${dc}
		   ),
	 yu as (
			 select
				y.babytree_enc_user_id,
				location_id
			 from
				${ytp} y
				join ${mtp} u using(babytree_enc_user_id)
		   )
select
	city_level,
	approx_distinct(babytree_enc_user_id)
from
	yu
	left join dldm using(location_id)
	left join hd on dldm.district_id=hd.district_id
	left join dc on hd.city_id=dc.city_id
group by
	1
"|grep -iv "SET">>${attach}
fi
