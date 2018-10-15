select
	id sub_order_id,
	original_total order_amt,
	total order_net_amt,
	case when sea_channel is not null then 1
	else 0 end sea_type_id
from
	salesorder.so_sub_order
where
	pay_time>='-time1'
	and pay_time<'-time2'
	and pay_code is not null
	and create_time>='-time3'
	and create_time<'-time2'
