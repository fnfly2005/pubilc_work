#!/bin/bash
#页面模块流量转化
source ${CODE_HOME-./}my_code/fuc.sh

mvp="`cas 1 partition_date` as dt,
    page_name_my,
    event_name_lv1,
    `cas 2 event_name_lv2` as event_name_lv2,
    `cas 2 item_index` as item_index,
    `cas 3 pagedpcity_id -99` as pagedpcity_id,
    app_name,"
upv="approx_distinct(union_id) as uv,
    count(1) as pv"
fmn() {
    echo "fmw.$1=isp.$1"
}
svf() {
    echo "sum(case when viewflag<>1 then $1 end)"
}
fus() {
    echo "
    select
        fmw.dt,
        `cas 4 value2` as pt,
        fmw.page_name_my,
        coalesce(city_name,'all') as city_name,
        fmw.event_name_lv1,
        fmw.event_name_lv2,
        fmw.item_index,
        sum(case when viewflag=1 then uv end) as view_uv,
        sum(case when viewflag=1 then pv end) as view_pv,
        `svf uv` as click_uv,
        `svf pv` as click_pv,
        `svf order_num` as order_num,
        `svf ticket_num` as ticket_num,
        `svf totalprice` as totalprice,
        `svf grossprofit` as grossprofit
    from (
        select
            $mvp
            case when event_type='view' then 1 else 0 end as viewflag,
            $upv
        `fun my_code/sql/detail_myshow_mv_wide_report.sql u`
            and page_cat<=2
            and page_name_my in ('\$page_name_my')
        group by
            1,2,3,4,5,6,7,8
        ) as fmw
        left join (
            select
                $mvp
                count(distinct spo.order_id) as order_num,
                sum(ticket_num) as ticket_num,
                sum(totalprice) as totalprice,
                sum(grossprofit) as grossprofit
            from (
                `fun my_code/sql/detail_myshow_salepayorder.sql`
                ) spo
                join (
                    `fun my_code/sql/detail_myshow_orderattribution.sql`
                    ) ion
                on spo.order_id=ion.order_id
            group by
                1,2,3,4,5,6,7
            ) isp
        on `fmn dt`
        and `fmn page_name_my`
        and `fmn event_name_lv1`
        and `fmn event_name_lv2`
        and `fmn item_index`
        and `fmn pagedpcity_id`
        and `fmn app_name`
        and fmw.viewflag=0
        join (
            `fun dim_myshow_dictionary.sql`
                and key_name='app_name'
                and value2 in ('\$app_name')
            ) as md
        on md.key=fmw.app_name
        left join (
            `fun my_code/sql/dim_myshow_city.sql`
            ) ity
        on fmw.pagedpcity_id=ity.city_id 
    group by 
        1,2,3,4,5,6,7
    ${lim-;}"
}

downloadsql_file $0
fuc $1
