/*城市维表*/
select 
    city_id,
    mt_city_id,
    city_name,
    province_id,
    province_name,
    area_1_level_id,
    area_1_level_name,
    area_2_level_id,
    area_2_level_name,
    region_code
from
    mart_movie.dim_myshow_city
where
    1=1