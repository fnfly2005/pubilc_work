#!/bin/bash
source ./my_code/fuc.sh
fmw=`fun detail_myshow_mv_wide_report.sql ut`
wmv=`fun my_code/sql/dim_myshow_mv.sql u`
mke=`fun my_code/sql/myshow_unused_key.sql`

fus() {
    echo "
    select
        mv_id,
        cp.page_identifier,
        cp.event_id,
        case when \$biz_par is null then ck
        when length(\$biz_par)<2 then ck
        else (\$biz_par || '&' || ck) end as ck
    from (
        select
            fp.page_identifier,
            fp.event_id,
            array_join(array_agg(fp.ck),'&','null') ck
        from (
            select distinct
                page_identifier,
                event_id,
                ck
            from (
                select
                    page_identifier,
                    event_id,
                    map_keys(\$custom) as cus_key
                $fmw
                    and map_keys(\$custom) is not null
                    and map_keys(\$custom)<>array[]
                group by
                    1,2,3
                ) fmv
                CROSS JOIN UNNEST(cus_key) as t (ck)
            where
                ck is not null
            ) fp
            left join (
                $mke
                ) mke
                on mke.unused_key=fp.ck
            left join (
                select distinct
                    page_identifier,
                    event_id,
                    ck
                from (
                    select
                        page_identifier,
                        event_id,
                        split(\$biz_par,'&') cus_key
                    $wmv
                        and \$biz_par is not null
                     ) wmv
                    CROSS JOIN UNNEST(cus_key) as t (ck)
                where 
                    ck is not null
                ) wp
            on wp.page_identifier=fp.page_identifier
            and wp.event_id=fp.event_id
            and wp.ck=fp.ck
        where
            wp.ck is null 
            and mke.unused_key is null
        group by
            1,2
        ) as cp
        left join (
            select
                mv_id,
                page_identifier,
                event_id,
                \$biz_par
            $wmv
            ) mv
        on mv.page_identifier=cp.page_identifier
        and mv.event_id=cp.event_id
    ${lim-;}"
}

downloadsql_file $0
fuc $1
