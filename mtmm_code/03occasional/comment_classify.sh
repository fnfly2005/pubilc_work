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

file="comment_classify"
attach="${path}00output/${file}_tp1.csv"
data="${path}00output/${file}_tp2.txt"
dict="${path}00output/${file}_dict.txt"
psc="${path}03occasional/comment_jieba_classify.py"
di="meitun_tmp.fannian_comment_dict"

presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"

${presto_e}"
${se}
with ci as (
		${ci}
		and mark in (1,2,4,5)
		),
	 ds as (
			 ${ds}
			 and category_lvl1_name='纸尿裤'
		   ),
	cd as (
	select
		case when mark in (1,2) then 'pos'
		else 'neg' end tag,
		content
	from
		ci
		join ds using(sku_id)
		),
	c1 as (
			select
				tag,
				content,
				row_number() over(partition by tag order by content) rank
			from
				cd
		  )
select
	tag,
	content
from
	c1
where
	rank<=3000
"|grep -iv "SET"|sed "s/\"//g">${attach}

${presto_e}"
select
	key,
	f
from
	${di}
"|sed "s/\"//g;s/,/ /g">${dict}

python ${psc} ${attach} ${data} ${dict}
