#!/bin/bash
#模块埋点业务参数复验工具
source ./my_code/fuc.sh
fmw=`fun detail_myshow_mv_wide_report.sql ut`
wmv=`fun my_code/sql/dim_myshow_mv.sql u`
mke=`fun my_code/sql/myshow_parkeylist.sql`

fus() {
    echo "
    select
        mv.mv_id,
        cp.page_identifier,
        cp.event_id,
        cp.ck,
        cp.biz_tag
    from (
        select
            fp.page_identifier,
            fp.event_id,
            array_join(array_agg(fp.ck),'&','null') ck,
            sum(distinct mke.biz_tag) as biz_tag
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
            join (
                $mke
                ) mke
                on mke.par_key=fp.ck
                and mke.is_myshow=1
            left join (
                select distinct
                    page_identifier,
                    event_id,
                    biz_tag,
                    ck
                from (
                    select
                        page_identifier,
                        event_id,
                        biz_tag,
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
        group by
            1,2
        having
            sum(if(wp.event_id is null,1,0))>0
        ) as cp
        left join (
            select
                mv_id,
                page_identifier,
                event_id
            $wmv
            ) mv
        on mv.page_identifier=cp.page_identifier
        and mv.event_id=cp.event_id
    ${lim-;}"
}

downloadsql_file $0
fuc $1
