/*商家dsr明细*/
select
	dt,
	supplier_id,
	product_degree,
	service_degree,
	logistics_degree
from
	dm_seller.seller_store_dsr
where
	dt>='-time1'
	and dt<'-time2'
