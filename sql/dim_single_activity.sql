/*单品活动表*/
select
	/*promotion_price_id*/single_activity_id promotion_id,
	single_activity_name topic_name
from
	dw.dim_single_activity
where
	sale_pattern in (6,8,16,1,24)
	and single_activity_name not like '%test%'
	and single_activity_name not like '%测试%'
	and single_activity_name is not null
