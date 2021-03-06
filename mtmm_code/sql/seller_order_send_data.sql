select
	dt,
	supplier_id,
	case when logistics_type=1 then 'guonei'
	when logistics_type=2 then 'zhiyou'
	when logistics_type=3 then 'baoshui'
	else 'other' end logistics_type,
	sub_order_num,
	upld_24hr_hour_num,
	upld_48hr_hour_num,
	upld_72hr_hour_num,
	exprss_24hour_num,
	exprss_48hour_num,
	exprss_72hour_num,
	exprss_120hour_num
from
	dm_seller.seller_order_send_data
where
	dt>='-time1'
	and dt<'-time2'
