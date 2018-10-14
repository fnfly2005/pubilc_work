#!/bin/bash
#cope to 25 or to 42
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
t3=`date -d "${t1% *} 1 days ago ${clock}" +"%Y-%m-%d %T"`
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
rhkko=`fun rpt_health_key_kpi_overview` 

file="rpt_health_key_kpi_overview"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

model=${attach/00output/model}
cp ${model} ${attach}

${presto_e}"
${se}
with rhkko as (
		${rhkko}
		),
temp as (select 1)
select
	*
from
	rhkko
"|grep -iv "SET">>${attach}

name=(
	fannian
	duyanhua
	liuxiaofei
	zhangxuechang
	qiuxu
	 )
script="${path}bin/mail.sh"
topic="﻿大健康数据日表"
content="﻿数据从${t1% *} 0点至${t2% *} 0点，邮件由系统发出，有问题请联系樊年"
address="tana1@babytree-inc.com, yanggangsong@babytree-inc.com, wangjing@babytree-inc.com"
for i in "${name[@]}"
do 
	address="${address}, ${i}@meitunmama.com"
done

bash ${script} "${topic}" "${content}" "${attach}" "${address}"
