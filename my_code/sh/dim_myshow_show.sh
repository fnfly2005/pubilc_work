#!/bin/bash
sql_name="演出场次维度表"
source ${CODE_HOME-./}/my_code/fuc.sh
source ${CODE_HOME-./}/my_code/fet.sh
downloadsql_file $0 e

fie="showid,
    bsshowid,
    name,
    starttime,
    endtime,
    isthrough,
    showtype,
    showseattype,
    editstatus,
    createtime,
    performanceid,
    originthroughtime,"
    
fus() {
echo "
`task origindb ${fil}`
#set \$onlinedt='2018-11-15'
$ins
select
    showid as show_id,
    bsshowid as activity_show_id,
    name as show_name,
    starttime as show_starttime,
    endtime as show_endtime,
    isthrough as show_isthrough,
    showtype as show_type,
    showseattype as show_seattype,
    editstatus,
    createtime as show_createtime,
    performanceid as performance_id,
    originthroughtime,
    offtime as show_offtime,
    show_online_flag,
    OnSaleTime as show_ontime,
    showid,
    projectshowid
from (
    select
        ${fie}
        offtime,
        case when editstatus=1 then 
            case when to_date(offtime)>'\$now.date' then 1 
            when to_date(offtime)='\$now.date' then 3
            else 2 end
        else 2 end as show_online_flag,
        CreateTime as OnSaleTime,
        TPSProjectShowID as projectshowid
    from (
        select 
            ${fie}
            case when offtime<'2016-01-01' then endtime
            else offtime end as offtime
        from (
            `fun my_code/sql/dp_myshow__s_show.sql`
                and createtime<'\$onlinedt'
            ) how 
        ) as sho
        left join (
            select
                ActivityShowID,
                max(TPSProjectShowID) TPSProjectShowID
            `fun my_code/sql/dp_myshow__bs_activityshowmap.sql u`
            group by
                ActivityShowID
            ) apm
        on apm.ActivityShowID=sho.bsshowid
    union all
    select
        ProjectShowID as showid,
        ProjectShowID as bsshowid,
        Name,
        StartTime,
        endtime,
        IsThrough,
        ShowType,
        ShowSeatType,
        EditStatus,
        CreateTime,
        ProjectID as performanceid,
        OriginThroughTime,
        offtime,
        case when editstatus=1 and status=1 then 
            case when to_date(offtime)>'\$now.date' then 1 
            when to_date(offtime)='\$now.date' then 3
            else 2 end
        else 2 end as show_online_flag,
        OnSaleTime,
        ProjectShowID
    from (
        select
            ProjectShowID,
            Name,
            StartTime,
            endtime,
            IsThrough,
            ShowType,
            ShowSeatType,
            EditStatus,
            CreateTime,
            ProjectID,
            OriginThroughTime,
            Status,
            coalesce(OffSaleTime,endtime) as offtime,
            coalesce(OnSaleTime,createtime) as OnSaleTime
        from (
            `fun my_code/sql/dp_myshow__tps_projectshow.sql`
                and createtime>=date_sub('\$onlinedt',1)
            ) pow
            left join (
            `fun my_code/sql/dp_myshow__bs_activityshowmap.sql`
                ) apm
            on apm.TPSProjectShowID=pow.ProjectShowID
            left join (
                select distinct
                    bsshowid
                `fun my_code/sql/dp_myshow__s_show.sql u`
                    and createtime<'\$onlinedt'
                ) sho
            on sho.bsshowid=apm.ActivityShowID
        where
            sho.bsshowid is null
        ) as sho
    ) how
$cre
\`show_id\` bigint COMMENT '融合场次ID-推荐使用',
\`activity_show_id\` bigint COMMENT '后台场次id',
\`show_name\` string COMMENT '场次名称',
\`show_starttime\` string COMMENT '场次开始时间',
\`show_endtime\` string COMMENT '场次结束时间',
\`show_isthrough\` int COMMENT '是否为通票场次',
\`show_type\` int COMMENT '场次类型 1:为单场票 2:为通票 3:为连票',
\`show_seattype\` int COMMENT '场次座位类型 0:非选座1:选座',
\`editstatus\` int COMMENT '0下架,1上架',
\`show_createtime\` string COMMENT '创建时间',
\`performance_id\` bigint COMMENT '融合演出ID-推荐使用',
\`originthroughtime\` string COMMENT '通票场次时间',
\`show_offtime\` string COMMENT '场次下架时间',
\`show_online_flag\` int COMMENT '1:在线,2:已结束,3:当日下架',
\`show_ontime\` string COMMENT '场次开售时间',
\`showid\` bigint COMMENT '场次ID-2018-11截止更新',
\`projectshowid\` bigint COMMENT '场次ID-2018-11前值不全'
`com`"
}

fuc $1 etl
