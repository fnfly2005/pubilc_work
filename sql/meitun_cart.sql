/*美囤电商购物车信息表*/
select
	dt,
	sku_code,
	cart_sku_num
from
	meitun.meitun_cart
where
	type=1
	and dt>='-time1'
	and dt<'-time2'
