/*拼团表*/
select
	id promotion_id,
	name topic_name,
	date_parse(start_time,'%Y-%m-%d %H:%i:%S') start_time,
	date_parse(end_time,'%Y-%m-%d %H:%i:%S') end_time
from
	ods.pr_activity_base
where
	name is not null
	and name not like '%test%'
	and name not like '%测试%'
