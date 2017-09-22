/*供应商名称表*/
select distinct
	supplier_id,
	supplier_name,
	substr(create_time,1,10) dt
from
	dw.dim_supplier
where
	status=1
	and supplier_name not like '%测试%'
