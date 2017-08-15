select
	sub_order_id,
	sub_order_code,
	sea_type_id,
	biz_unit biz_unit_id,
	delivered_time,
	order_amt,
	pay_time,
	province_name
from
	dw.sale_sub_order
where
	dt>='-time3'
	and dt<'-time2'
	and pay_time>='-time1'
	and pay_time<'-time2'
