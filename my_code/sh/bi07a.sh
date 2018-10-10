#!/bin/bash
#埋点逻辑数据验证工具
source ./my_code/fuc.sh
fpw=`fun detail_flow_pv_wide_report.sql u`
fmw=`fun detail_flow_mv_wide_report.sql u`

fus() {
echo "
select 
    app_name,
    page_identifier,
	event_id,
    custom,
    custom_key,
    utm_source,
    \$custom_id,
    page_city_id,
    geo_city_id,
	event_category,
	event_type,
	event_attribute,
    event_attribute_key,
	order_id
from (
    select
        app_name,
        page_identifier,
        event_id,
        custom,
        map_keys(custom) as custom_key,
        utm_source,
        \$custom_id,
        page_city_id,
        geo_city_id,
        event_category,
        event_type,
        event_attribute,
        map_keys(event_attribute) as event_attribute_key,
        order_id,
        row_number() over (partition by \$event_id order by 1) as rank
    from (
        select distinct
            app_name,
            page_identifier,
            event_id,
            custom,
            utm_source,
            \$custom_id,
            page_city_id,
            geo_city_id,
            event_category,
            event_type,
            event_attribute,
            order_id
        from (
            select
                app_name,
                page_identifier,
                page_identifier as event_id,
                'all' as event_category,
                'all' as event_type,
                custom as event_attribute,
                'all' as order_id,
                page_city_id,
                geo_city_id,
                custom,
                utm_source,
                \$custom_id,
                row_number() over (partition by page_identifier order by 1) as rak
            $fpw
                and 1 in (\$type)
                and substr(stat_time,12,2)>='\$ht'
                and (
                    page_identifier in (
                        select
                            identifier
                        from 
                            upload_table.myshow_identifier_ver
                        where
                            \$mod=1
                        union all
                        select
                            page_identifier as identifier
                        from 
                            mart_movie.dim_myshow_pv
                        where
                            \$mod=3
                            and (regexp_like(page_name_my,'\$sdk_name')
                                or '\$sdk_name'='全部')
                        )
                    or (page_identifier in ('\$identifier') and \$mod=0)
                    )
                and app_name in ('\$app_name')
            union all
            select
                app_name,
                page_identifier,
                event_id,
                event_category,
                event_type,
                event_attribute,
                order_id,
                page_city_id,
                geo_city_id,
                custom,
                utm_source,
                \$custom_id,
                row_number() over (partition by event_id order by 1) as rak
            $fmw
                and 2 in (\$type)
                and substr(stat_time,12,2)>='\$ht'
                and (
                    event_id in (
                        select
                            identifier
                        from 
                            upload_table.myshow_identifier_ver
                        where
                            \$mod=1
                        union all
                        select
                            event_id as identifier
                        from 
                            mart_movie.dim_myshow_mv
                        where
                            \$mod=3
                            and (regexp_like(event_name_lv1,'\$sdk_name')
                                or '\$sdk_name'='全部')
                        )
                    or (page_identifier in ('\$identifier') and \$mod=0)
                    or (event_id in ('\$identifier') and \$mod=2)
                    )
                and app_name in ('\$app_name')
            ) as fw
        where
            rak<=1000
        ) as rk
    ) as ran
where
    rank<=\$limit
${lim-;}"
}

downloadsql_file $0
fuc $1
