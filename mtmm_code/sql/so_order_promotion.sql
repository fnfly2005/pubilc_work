select
	sub_order_id,
	discount
from
	salesorder.so_order_promotion
where
	source_type=1
	and create_time>='-time3'
	and create_time<'-time2'
