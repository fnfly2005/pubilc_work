/*团购结算*/
select
    substr(pay_time,1,10) dt,
    order_id,
    deal_id,
    quantity,
    purchase_price
from
    mart_movie.detail_maoyan_order_sale_cost_new_info
where
    pay_time>='$$begindate'
    and pay_time<'$$enddate'
    and deal_id in (
        select 
            deal_id
        from 
            mart_movie.dim_deal_new
        where 
            category=12
        )
