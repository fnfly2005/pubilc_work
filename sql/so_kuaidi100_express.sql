select
	sub_order_code,
	max(dt) dt
from
	ods.so_kuaidi100_express
where
	delivery_order_type=0
	and is_check='1'
	and dt>='-time1'
	and dt<'-time2'
group by
	1
