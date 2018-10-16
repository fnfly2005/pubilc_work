#!/bin/bash
#报送腾讯投资月报在线数据
source ${CODE_HOME-./}my_code/fuc.sh

fus() {
    echo "
    select
        `diffmonth` as mt,
        sum(totalprice) as totalprice,
        sum(ticket_num) as ticket_num
    from (
        select
            sum(totalprice) as totalprice,
            sum(setnumber*salesplan_count) as ticket_num
        `fun my_code/sql/detail_myshow_salepayorder.sql uD`
            `diffmonth_condition partition_date`
        union all
        select
            sum(purchase_price) as totalprice,
            sum(quantity) as ticket_num
        `fun my_code/sql/detail_maoyan_order_sale_cost_new_info.sql uD`
            `diffmonth_condition pay_time`
            and deal_id in (
                select
                    deal_id
                `fun my_code/sql/dim_deal_new.sql u`
                )
        union all
        select
            sum(totalprice) as totalprice,
            sum(ticket_num) as ticket_num
        `fun my_code/sql/sale_offline.sql uD`
            `diffmonth_condition dt`
        ) so
    ${lim-;}"
}

downloadsql_file $0
fuc $1
