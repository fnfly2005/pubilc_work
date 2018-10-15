#!/bin/bash
clock=10
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days ${clock}" +"%Y-%m-%d %T"`}
t3=`date -d "${t1% *} -1days ${clock}" +"%Y-%m-%d %T"`
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
rh=`fun rpt_health_course_detail_daily` 

file="djk07"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with rh as (
		${rh}
		),
temp as (select 1)
	select
		mt,
		course_id,
		course_name,
		course_catagory_name,
		expert_name,
		organization_name,
		avg(course_price) course_price,
		sum(home_play_pv) home_play_pv,
		sum(home_otherplay_pv) home_otherplay_pv,
		sum(pay_click_pv) pay_click_pv,
		sum(commend_click_pv) commend_click_pv,
		sum(voice_play_times) voice_play_times,
		sum(voice_play_custs) voice_play_custs,
		sum(total_gmv) total_gmv,
		sum(cust_num) cust_num,
		sum(new_cust_num) new_cust_num,
		sum(uv) uv,
		sum(pay_uv) pay_uv
	from
		rh
	group by
		1,2,3,4,5,6
	union all
	select
		'all' mt,
		course_id,
		course_name,
		course_catagory_name,
		expert_name,
		organization_name,
		avg(course_price) course_price,
		sum(home_play_pv) home_play_pv,
		sum(home_otherplay_pv) home_otherplay_pv,
		sum(pay_click_pv) pay_click_pv,
		sum(commend_click_pv) commend_click_pv,
		sum(voice_play_times) voice_play_times,
		sum(voice_play_custs) voice_play_custs,
		sum(total_gmv) total_gmv,
		sum(cust_num) cust_num,
		sum(new_cust_num) new_cust_num,
		sum(uv) uv,
		sum(pay_uv) pay_uv
	from
		rh
	group by
		1,2,3,4,5,6
"|grep -iv "SET">${attach}
