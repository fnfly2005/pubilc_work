#!/bin/bash
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
ag=`fun appcontentclicklog_gz` 
aeg=`fun appcontentclicklog_exps_gz` 
tp="tmp.yunyu_fannian_tcode"

file="test"
attach1="${path}00output/${file}1.csv"
attach2="${path}00output/${file}2.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with ag as (
		${ag}
		and regexp_like(action_extend,'yy_djk_kj_')
		and action_event='2'
		),
temp as (select 1)
			select distinct
				regexp_extract(action_extend,'yy_djk_kj_([a-z]+)') tcode,
				content_id,
				action_event,
				action_params,
				action_extend,
				pageid,
				item_id
			from
				ag
"|grep -iv "SET">${attach1}
${presto_e}"
${se}
with aeg as (
			${aeg}
			and regexp_like(action_extend,'yy_djk_kj_')
			and action_event='1'
		   ),
temp as (select 1)
			select distinct
				regexp_extract(action_extend,'yy_djk_kj_([a-z]+)') tcode,
				content_id,
				action_event,
				action_params,
				action_extend,
				pageid,
				item_id
			from
				aeg
"|grep -iv "SET">${attach2}
