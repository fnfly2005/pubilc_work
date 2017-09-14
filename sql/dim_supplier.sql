/*供应商名称表*/
select distinct
	supplier_id,
	supplier_name
from
	dw.dim_supplier
where
	status=1
