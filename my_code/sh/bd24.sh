#!/bin/bash
#项目销售-全量-多维度-多指标
source ${CODE_HOME-./}my_code/fuc.sh

spo=`fun detail_myshow_saleorder.sql`
dmp=`fun dim_myshow_performance.sql`
dc=`fun dim_myshow_customer.sql`
md=`fun dim_myshow_dictionary.sql`

fus() {
echo "
select
    case when 0 in (\$dim) then mt
    else 'all' end as mt,
    case when 1 in (\$dim) then dt
    else 'all' end as dt,
    case when 2 in (\$dim) then md.value2 
    else 'all' end as pt,
    case when 3 in (\$dim) then customer_type_name
    else 'all' end as customer_type_name,
    case when 3 in (\$dim) then customer_lvl1_name
    else 'all' end as customer_lvl1_name,
    case when 4 in (\$dim) then customer_name
    else 'all' end as customer_name,
    area_1_level_name,
    area_2_level_name,
    dmp.province_name,
    dmp.city_name,
    dmp.category_name,
    spo.performance_id,
    dmp.performance_name,
    dmp.shop_name,
    bd_name,
    count(distinct order_id) as order_num,
    sum(ticket_num) as ticket_num,
    sum(TotalPrice) as TotalPrice,
    sum(grossprofit) as grossprofit
from (
    $spo
    ) spo
    join (
        $dmp
            and category_id in (\$category_id)
        ) dmp
    using(performance_id)
    left join (
    $dc
    ) dc
    on spo.customer_id=dc.customer_id
    left join (
        $md
        and key_name='sellchannel'
    ) md
    on md.key=spo.sellchannel
group by
    1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
${lim-;}"
}

downloadsql_file $0
fuc $1
