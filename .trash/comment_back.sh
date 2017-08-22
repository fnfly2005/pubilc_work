#!/bin/bash
#cope to 25 or to 42
clock=10
t1=${1:-`date -d "yesterday ${clock}" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${sta% *} -1 days ago ${clock}" +"%Y-%m-%d %T"`}
t3=`date -d "${sta% *} 1 days ago ${clock}" +"%Y-%m-%d %T"`
path="/home/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
ci=`fun comment_item` 

file="comment"
attach="${path}00output/${file}_tp1.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"
${presto_e}"
${se}
with ci as (
		${ci}
		)
select
	comment_id,
	content
from
	ci
"|grep -iv "SET">${attach}
sed -i "s/\"//g" ${attach}

psc="/home/fannian/03occasional/comment.py"

python ${psc}

tp="tmp.fannian_comment_test2"
data="/home/fannian/00output/comment_tp2.csv"

hive_e="/opt/hive/bin/hive -e "
${hive_e}"
load data local inpath '${data}' into table ${tp};"
