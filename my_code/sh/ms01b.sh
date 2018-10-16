#!/bin/bash
#报送腾讯投资月报销售数据
source ${CODE_HOME-./}my_code/fuc.sh

fus() {
    echo "
    select
        `diffmonth` as mt,
        sum(shp_num) as shp_num,
        sum(per_num) as per_num
    from (
        select
            count(distinct shop_id) as shp_num,
            count(distinct performance_id) as per_num
        `fun my_code/sql/detail_myshow_salesplan.sql uD`
            partition_date=`diffmonth 10 '$$monthfirst{1m,-1d}'`
            and customer_type_id=2
            and salesplan_sellout_flag=0
        union all
        select
            count(distinct eal.shopid) as shp_num,
            count(distinct eal.dealid) as per_num
        from 
            origindb.dp_myshow__s_deal eal
            join (
            select
                deal_id
            `fun my_code/sql/dim_deal_new.sql u`
                and dealstatus='\"online\"'
                and endtime>concat('\"','\$\$today{-1d}',' 00:00:00\"')
            ) as dn
            on eal.MYDealID=dn.deal_id
        ) as di
    ${lim-;}"
}

downloadsql_file $0
fuc $1
