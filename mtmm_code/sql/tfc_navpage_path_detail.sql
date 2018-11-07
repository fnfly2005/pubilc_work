/*流量漏斗表*/
select
	dt,
	sku_code,
	item_sku,
	uuid,
	item_track_id,
	navpage_track_id,
	cart_track_id,
	track_flag,
	order_pay_flag,
	parent_order_id,
	sensitive_enc_user_id
from
	dw.tfc_navpage_path_detail
where
	platform_source in ('android','btm-android','ios','btm-ios','m','pc')
	and dt>='-time1'
	and dt<'-time2'
