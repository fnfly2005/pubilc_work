/*合同类目品牌表*/
select distinct
	contract_id,
	brand_id,
	brand_name
from
	ods.sp_contract_product
where
	status=1
