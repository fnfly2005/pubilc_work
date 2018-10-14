select
	brand_id,
	brand_name
from
	dw.dim_brand
where
	brand_status=1
