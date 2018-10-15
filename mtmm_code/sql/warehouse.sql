/*仓库表*/
select
	sp_id supplier_id,
	sp_name supplier_name,
	id warehouse_id,
	name warehouse_name,
	case when type=4 then '保税区'
	when type=5 then '境外直发'
	else '其他' end warehouse_type,
	bonded_area sea_channel_id
from
	ods.warehouse
