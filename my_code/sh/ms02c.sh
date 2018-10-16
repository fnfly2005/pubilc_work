#!/bin/bash
#模块埋点业务参数复验工具
source ./my_code/fuc.sh
wmv=`fun my_code/sql/dim_myshow_mv.sql u`
fmv=`fun detail_myshow_mv_wide_report.sql ut`
cus() {
    echo "
        select distinct
            page_identifier,
            event_id,
            ck,
            if('$1'='event_attribute',1,0) as par_type
        from (
            select
                page_identifier,
                event_id,
                map_keys($1) as cus_key
           $fmv 
                and map_keys($1) is not null
                and map_keys($1)<>array[]
            group by
                1,2,3
            ) fmv
            CROSS JOIN UNNEST(cus_key) as t (ck)
        where
            ck is not null
    "
}
biz() {
    echo "
        select distinct
            page_identifier,
            event_id,
            biz_tag,
            ck,
            if('$1'='biz_typ',1,0) as par_type
        from (
            select
                page_identifier,
                event_id,
                biz_tag,
                split($1,'&') cus_key
            $wmv
                and $1 is not null
             ) wmv
            CROSS JOIN UNNEST(cus_key) as t (ck)
        where 
            ck is not null
            and ck<>''
    "
}
reg() {
    echo "regexp_replace(regexp_replace($1,'&[&]+','&'),'^&|&$')"
}

fus() {
    echo "
    select
        mv.mv_id,
        cp.page_identifier,
        cp.event_id,
        cp.biz_tag,
        `reg cp.cus_ck` as cus_ck,
        `reg cp.eve_ck` as eve_ck
    from (
        select
            fp.page_identifier,
            fp.event_id,
            sum(distinct mke.biz_tag) as biz_tag,
            array_join(array_agg(case when fp.par_type=0 then fp.ck end),'&','') cus_ck,
            array_join(array_agg(case when fp.par_type=1 then fp.ck end),'&','') eve_ck
        from (
            `cus custom`
            union all
            `cus event_attribute`
            ) fp
            join (
                `fun my_code/sql/dim_myshow_parkeylist.sql`
                ) mke
                on mke.par_key=fp.ck
                and mke.is_myshow=1
            left join (
                `biz biz_par`
                union all
                `biz biz_typ`
                ) wp
            on wp.page_identifier=fp.page_identifier
            and wp.event_id=fp.event_id
            and wp.ck=fp.ck
            and wp.par_type=fp.par_type
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
