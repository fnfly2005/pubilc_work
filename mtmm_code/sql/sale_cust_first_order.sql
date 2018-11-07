select distinct
	sensitive_enc_user_id	
from
	dw.sale_cust_first_order
where
	first_pay_order_date_id>='-time1'
	and first_pay_order_date_id<'-time2'
