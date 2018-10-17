#!/bin/bash
#埋点键值核验工具
source ./my_code/fuc.sh
fmw=`fun detail_myshow_mv_wide_report.sql ut`

fus() {
    echo "
        select distinct
            fp.ck as par_key,
            is_myshow,
            biz_tag,
            tag_name
        from (
            select distinct
                ck
            from (
                select
                    map_keys(custom) as cus_key
                $fmw
                    and map_keys(custom) is not null
                    and map_keys(custom)<>array[]
                group by
                    1
                ) fmv
                CROSS JOIN UNNEST(cus_key) as t (ck)
            where
                ck is not null
            union all
            select distinct
                ck
            from (
                select
                    map_keys(event_attribute) as cus_key
                $fmw
                    and map_keys(event_attribute) is not null
                    and map_keys(event_attribute)<>array[]
                group by
                    1
                ) fmv
                CROSS JOIN UNNEST(cus_key) as t (ck)
            where
                ck is not null
            union all
            select distinct
                ck
            from (
                select
                    map_keys(custom) as cus_key
                `fun detail_myshow_pv_wide_report.sql ut`
                    and partition_biz_bg<2
                    and map_keys(custom) is not null
                    and map_keys(custom)<>array[]
                group by
                    1
                ) fpw
                CROSS JOIN UNNEST(cus_key) as t (ck)
            where
                ck is not null
            ) fp
            left join (
                `fun my_code/sql/dim_myshow_parkeylist.sql`
                ) mke
            on mke.par_key=fp.ck
        where
            mke.par_key is null
            or is_myshow=1
    ${lim-;}"
}

downloadsql_file $0
fuc $1
