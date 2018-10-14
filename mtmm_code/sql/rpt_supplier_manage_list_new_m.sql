/*商家管理报表*/
select
	round(dsr_sku,2) product_degree,
	round(dsr_service,2) service_degree,
	round(dsr_transfer,2) logistics_degree
from
	rpt.rpt_supplier_manage_list_new_m
where
	substr(mth_id,1,7)='-time1'
	and sea_type_id=-99
	and category_lvl1_id=-99
	and supplier_id=-99
