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
rh=`fun rpt_health_course_detail_ral_test` 

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
		course_type,
		sum(listen_gmv) listen_gmv,
		sum(cust_num) cust_num,
		sum(new_cust_num) new_cust_num,
		sum(voice_num) voice_num,
		sum(ask_question_num) ask_question_num,
		sum(expert_answer_num) expert_answer_num,
		sum(award_cust_num) award_cust_num,
		sum(award_amount) award_amount,
		sum(course_like_num) course_like_num,
		sum(uv) uv,
		sum(diversion_uv) diversion_uv,
		sum(r_uv) r_uv,
		sum(voice_play_times) voice_play_times,
		avg(course_price) course_price
	from
		rh
	group by
		1,2,3,4,5,6,7
	union all
	select
		'all' mt,
		course_id,
		course_name,
		course_catagory_name,
		expert_name,
		organization_name,
		course_type,
		sum(listen_gmv) listen_gmv,
		sum(cust_num) cust_num,
		sum(new_cust_num) new_cust_num,
		sum(voice_num) voice_num,
		sum(ask_question_num) ask_question_num,
		sum(expert_answer_num) expert_answer_num,
		sum(award_cust_num) award_cust_num,
		sum(award_amount) award_amount,
		sum(course_like_num) course_like_num,
		sum(uv) uv,
		sum(diversion_uv) diversion_uv,
		sum(r_uv) r_uv,
		sum(voice_play_times) voice_play_times,
		avg(course_price) course_price
	from
		rh
	group by
		1,2,3,4,5,6,7
"|grep -iv "SET">${attach}
