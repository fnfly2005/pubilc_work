/*dw子单表*/
select
	dt,
	sub_order_id,
	sub_order_code,
	parent_order_id,
	supplier_id,
	warehouse_id,
	sea_type_id,
	biz_unit biz_unit_id,
	order_status,
	pay_time,
	done_time,
	delivered_time,
	cast(approve_time as varchar) approve_time,
	cast(express_time as varchar) express_time,
	order_amt,
	province_name
from
	dw.sale_sub_order
where
	dt>='-time3'
	and dt<'-time2'
	and pay_time>='-time1'
	and pay_time<'-time2'
