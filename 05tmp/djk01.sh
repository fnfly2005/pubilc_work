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

file="djk01"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"
model=${attach/00output/model}
cp ${model} ${attach}

${presto_e}"
${se}
with ag as (
		${ag}
		and regexp_like(action_extend,'yy_djk_kj_')
		),
	agj as (
			select
				regexp_extract(action_extend,'yy_djk_kj_([a-z]+)') tcode,
				count(1) cpv,
				count(distinct uuid) cuv
			from
				ag
			group by
				1
		   ),
	aeg as (
			${aeg}
			and regexp_like(action_extend,'yy_djk_kj_')
		   ),
	aegj as (
			select
				regexp_extract(action_extend,'yy_djk_kj_([a-z]+)') tcode,
				count(1) bpv,
				count(distinct uuid) buv
			from
				aeg
			group by
				1
		   ),
temp as (select 1)
	select
		'${t1% *}' dt,
		position,
		bpv,
		buv,
		cpv,
		cuv
	from
		agj
		left join aegj using(tcode)
		join ${tp} tp on agj.tcode=tp.tcode
"|grep -iv "SET">>${attach}

name=(
	fannian
	duyanhua
	 )
script="${path}bin/mail.sh"
topic="﻿大健康开讲曝光导流日报${t1% *}"
content="﻿数据从${t1% *} 0点至${t2% *} 0点，目前曝光表无法完全匹配到点击表，所以曝光数据有缺失，等待下次改版解决，邮件由系统发出，有问题请联系樊年"
address="wangyu1@babytree-inc.com, liumingming@babytree-inc.com, huangjing@babytree-inc.com, zhangyanling@babytree-inc.com"
for i in "${name[@]}"
do 
	address="${address}, ${i}@meitunmama.com"
done
bash ${script} "${topic}" "${content}" "${attach}" "${address}"
