/*区域地区对照表*/
select distinct
	location_id,
	district_id
from
	dw.dim_location_district_match
