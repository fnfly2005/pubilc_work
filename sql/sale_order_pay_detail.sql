select
	dt,
	case track_source
		when 1 then 'PC'
		when 3 then 'WAP'
		when 5 then 'IOS'
		when 6 then 'ANDROID'
		when 8 then 'BTM-IOS'
		when 9 then 'BTM-ANDROID'
	else 'BTM' end track_source,
	sea_type_id,
	biz_unit,
	order_line_id,
	babytree_enc_user_id,
	parent_order_type,
	promotion_id,
	topic_id,
	brand_id,
	sku_id,
	parent_order_id,
	sub_order_id,
	supplier_id,
	sku_num,
	order_amt,
	order_net_amt,
	pay_pregnant_month,
	province_id,
	used_point
from
	dw.sale_order_pay_detail
where
	dt>='-time1'
	and dt<'-time2'
