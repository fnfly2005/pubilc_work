/*检票记录表*/
select
    orderID as order_id,
    qrcode,
    CheckStatus
from
    origindb.dp_myshow__s_orderticket
where
    CreateTime>='$$begindate'
    and CreateTime<'$$enddate'
