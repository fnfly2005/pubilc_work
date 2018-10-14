select
	coupon_id,
	babytree_enc_user_id
from
	dw.sale_order_promotion
where
	dt>='-time3'
	and promotion_type=1
	and pay_time>='-time1'
	and pay_time<'-time2'
	and dt<'-time2'
