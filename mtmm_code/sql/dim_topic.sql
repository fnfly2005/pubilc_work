select
	topic_id,
	topic_name,
	topic_type_id
from
	dw.dim_topic
where
	topic_type_id in (1,2,3)
	and topic_name is not null
	and topic_name not like '%test%'
	and topic_name not like '%测试%'
