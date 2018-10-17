/*演出订单归因表*/
select
    partition_date,
    app_name,
    event_name_lv1,
    event_name_lv2,
    item_index,
    page_name_my,
    pagedpcity_id,
    order_id,
    sequence
from 
    mart_movie.detail_myshow_orderattribution
where
    partition_date>='$$begindate'
    and partition_date<'$$enddate'
