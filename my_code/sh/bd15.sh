#!/bin/bash
#项目购票信息
source ./fuc.sh
so=`fun detail_myshow_saleorder.sql D`
soi=`fun dp_myshow__s_orderidentification.sql u`
md=`fun dim_myshow_dictionary.sql`
ket=`fun dp_myshow__s_orderticket.sql`

downloadsql_file $0

fus() {
echo "
select
    so.order_id,
    maoyan_order_id,
    md2.value2 as pt,
    UserName,
    IDNumber,
    mobile,
    meituan_userid,
    so.performance_id,
    so.performance_name,
    order_create_time,
    pay_time,
    md.value2,
    show_id,
    show_name,
    show_starttime,
    show_endtime,
    ticket_price,
    salesplan_name,
    province_name,
    city_name,
    district_name,
    detailedaddress,
    ticket_num,
    totalprice,
    qrcode,
    if(CheckStatus=0,'未检票','已检票') as CheckStatus
from (
    $so
        pay_time is not null
        and ((pay_time>='\$\$begindate'
        and pay_time<'\$\$enddate')
        or 1=\$pay_flag)
        and performance_id in (\$performance_id)
    ) so
    join (
        $md
        and key_name='sellchannel'
        and key1>'0'
        ) md2
    on md2.key=so.sellchannel
    left join (
        $md
        and key_name='order_refund_status'
        ) md
    on md.key=so.order_refund_status
    left join (
        select
            OrderID as order_id,
            UserName,
            IDNumber
        $soi
            and performanceid in (\$performance_id)
            and \$typ=1
        ) soi
    using(order_id)
    left join (
        $ket
        and qrcode is not null
        and createtime>'2017-11-17'
        and \$typ=2
        ) as ket
    on ket.order_id=so.order_id
${lim-;}"
}

fuc $1
