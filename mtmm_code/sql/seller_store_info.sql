/*店铺商家表*/
select
	sp_id supplier_id
from
	ods.seller_store_info
where
	open_custom_service=1
	and custom_team_ids is not null
	and store_status=1
