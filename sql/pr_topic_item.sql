select
	topic_id,
	sku sku_code,
	mt_subsidy_amount
from
	ods.pr_topic_item
where
	approve_status=0
	and deletion=0
	and is_test=0
