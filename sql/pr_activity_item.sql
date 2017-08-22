/*拼团商品表*/
select
	activity_id promotion_id,
	avg(activity_price) activity_price
from
	ods.pr_activity_item
group by
	1
