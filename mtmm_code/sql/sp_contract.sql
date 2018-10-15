/*合同表*/
select
	id contract_id,
	case when isseawashes=1 then '海淘'
	else '国内' end isseawashes,
	supplier_id,
	supplier_name
from
	ods.sp_contract
where
	status=1
	and end_date>='-time1'
	and start_date<'-time1'
