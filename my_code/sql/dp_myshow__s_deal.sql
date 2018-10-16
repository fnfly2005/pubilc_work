/*团购维表*/
select
    dealid as deal_id,
    cityid as city_id,
    shopid as shop_id,
    createtime,
    MYDealID
from
    origindb.dp_myshow__s_deal
