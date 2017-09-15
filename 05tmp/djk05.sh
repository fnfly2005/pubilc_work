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
#ag=`fun appcontentclicklog_gz` 
dmsg=`fun djk_m_sourceubtpageview_gz ${t3% *}`

file="djk05"
attach="${path}00output/${file}.csv"
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
se="set session optimize_hash_generation=true;"
tp="test.djk_js_uuid_fn_test"

model=${attach/00output/model}

if [ 1 = 1 ]
then
${presto_e}"
${se}
insert into ${tp}
with dmsg as (
		${dmsg}
		and regexp_like(trackercode,'djk_js_')
		and dt='${t1% *}'
		),
	 d1 as (
			select
				uuid,
				max(case when regexp_like(trackercode,'djk_js_lesson') 
						then 1 else 0 end) isplay
			from
				dmsg
			group by
				1
		   ),
	 d2 as (
			 select
				 d1.uuid,
				 0 isplay
			 from
				d1
				left join ${tp} t using(uuid)
			where
				t.uuid is null
			union all
			 select
				d1.uuid,
				1 isplay
			 from
				d1
				left join ${tp} t on d1.uuid=t.uuid 
				and t.isplay=1
			where
				t.uuid is null
				and d1.isplay=1
		   ),
temp as (select 1)
	select
		'${t1% *}' dt,
		uuid,
		max(isplay) isplay
	from
		d2
	group by
		1,2
"
fi

if [ 1 = 1 ]
then
cp ${model} ${attach}
${presto_e}"
${se}
with dmsg as (
		${dmsg}
		and regexp_like(trackercode,'djk_js_')
		),
	 d1 as (
			select
				'${t1% *}' dt,
				count(1) pv,
				count(distinct uuid) uv,
				count(distinct case when 
						regexp_like(trackercode,'djk_js_lesson') 
						then uuid end) playuv
			from
				dmsg
			where
				dt='${t1% *}'
		   ),
	 d2 as (
			 select
				'${t1% *}' dt,
				count(distinct da.uuid) suv,
				count(distinct case when regexp_like(da.trackercode,'djk_js_lesson')
					then da.uuid end) playsuv
			 from
				dmsg da
				join dmsg db on da.uuid=db.uuid and da.dt<>db.dt
		   ),
	 tp as (
			 select
				'${t1% *}' dt,
				count(uuid) nuv,
				count(case when isplay=1 then uuid end) playnuv
			 from
				${tp}
			where
				dt='${t1% *}'
		   ),
temp as (select 1)
	select
		d1.dt,
		pv,
		uv,
		playuv,
		suv,
		playsuv,
		nuv,
		playnuv
	from
		d1 join d2 using(dt)
		join tp on d1.dt=tp.dt
"|grep -iv "SET">>${attach}

script="${path}bin/mail.sh"
topic="﻿健身流量日报"
content="﻿数据从${t1% *} 0点至${t2% *} 0点，邮件由系统发出，有问题请联系樊年"
address="fannian@meitunmama.com"
mt_name=(
		duyanhua
	 )
bb_name=(
		yanzhenlong
		liumingming
		haoxiaolin
		tianmingzhu
		fulei
	)
for i in "${mt_name[@]}"
do 
	address="${address}, ${i}@meitunmama.com"
done
for i in "${bb_name[@]}"
do 
	address="${address}, ${i}@babytree-inc.com"
done
bash ${script} "${topic}" "${content}" "${attach}" "${address}"
fi
