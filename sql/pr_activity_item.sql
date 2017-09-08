/*拼团商品表*/
select
	activity_id promotion_id,
	sku sku_code,
	activity_price
from
	ods.pr_activity_item
