select 
	supplier_id
from
	ods.sp_contract
where
	status=1
	and end_date>='-time1'
	and start_date<'-time1'
