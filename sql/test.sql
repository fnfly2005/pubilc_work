select
	status,
	count(1) pv
from
	ods.com_item_review
where
	is_import=0
	and is_check=2
	and is_hide=2
group by
	1
;
