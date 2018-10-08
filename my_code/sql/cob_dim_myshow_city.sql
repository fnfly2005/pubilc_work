/*地域过滤*/
(( city_id in ($city_id) 
    and 1 in ($cp)) 
or ( city_id in ( 
    select 
        city_id 
    from 
        mart_movie.dim_myshow_city 
    where 
        province_id in ($province_id) ) 
        and 2 in ($cp) ) 
or 3 in ($cp) )
