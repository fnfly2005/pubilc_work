select
	sku_id,
	spu_id,
	sku_code,
	barcode,
	spu_name,
	prod_name,
	basic_price,
	brand_name,
	sea_type_name sea_type,
	biz_unit_name biz_unit,
	supplier_id,
	supplier_name,
	category_lvl1_name,
	category_lvl2_name,
	category_lvl3_name,
	modify_time
from
	dw.dim_sku ds
	join dw.dim_sea_type dst using(sea_type_id)
	join test.dim_biz_unit dbu on dbu.biz_unit_id=ds.biz_unit
where
	category_lvl1_name is not null
	and category_lvl1_name not like '%test%'
	and category_lvl1_name not like '%测试%'
	and prod_name not like '%test%'
	and prod_name not like '%测试%'
	and supplier_name not like '%测试%'
