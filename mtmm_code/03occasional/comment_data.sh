#!/bin/bash
t1=${1:-`date -d "yesterday" +"%Y-%m-%d %T"`}
t2=${2:-`date -d "${t1% *} 1days" +"%Y-%m-%d %T"`}
path="/data/fannian/"
fun() {
echo `cat ${path}sql/${1}.sql | sed "s/-time1/${2:-${t1% *}}/g;
s/-time2/${3:-${t2% *}}/g;s/-time3/${4:-${t3% *}}/g"`
}
ci=`fun comment_item` 
ds=`fun dim_sku`

file="comment"
attach="${path}00output/${file}_tp1.csv"
data="${path}00output/${file}_tp2.csv"
data2="${path}00output/${file}_tp3.csv"
dict="${path}00output/${file}_dict.txt"
psc="${path}03occasional/comment_jieba.py"
tp="meitun_tmp.fannian_comment_word"
st="meitun_tmp.fannian_comment_stopword"
di="meitun_tmp.fannian_comment_dict"

presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

if [ 1 = 1 ]
then
${presto_e}"
${se}
with ci as (
		${ci}
		and mark=1
		and service_mark=1
		and transport_mark=1
		),
	 ds as (
			 ${ds}
			 and category_lvl1_name='纸尿裤'
		   )
select
	comment_id,
	content
from
	ci
	join ds using(sku_id)
limit 100
"|grep -iv "SET"|sed "s/\"//g">${attach}
fi

${presto_e}"
select
	key,
	f
from
	${di}
"|sed "s/\"//g;s/,/ /g">${dict}

python ${psc} ${attach} ${data} ${dict}

if [ 1 = 1 ]
then
hive_e="/opt/hive/bin/hive -e "
${hive_e}"
truncate table ${tp};
load data local inpath '${data}' into table ${tp};"

${presto_e}"
${se}
select
	tp.*
from
	${tp} tp
	left join ${st} st using(key)
where
	st.key is null
"|grep -iv "SET"|sed "s/\"//g">${data2}
fi
