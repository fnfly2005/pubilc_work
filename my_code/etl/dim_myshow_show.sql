

##Description##

##TaskInfo##
creator = 'fannian@maoyan.com'

source = {
    'db': META['horigindb'], 
}

stream = {
    'format': '', 
}

target = {
    'db': META['hmart_movie'], 
    'table': 'dim_myshow_show', 
} 
##Extract##

##Preload##

##Load##
#set $onlinedt='2018-11-15'
insert OVERWRITE TABLE `$target.table`
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
        showid,
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
    originthroughtime,
        offtime,
        case when editstatus=1 then 
            case when to_date(offtime)>'$now.date' then 1 
            when to_date(offtime)='$now.date' then 3
            else 2 end
        else 2 end as show_online_flag,
        CreateTime as OnSaleTime,
        TPSProjectShowID as projectshowid
    from (
        select 
            showid,
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
    originthroughtime,
            case when offtime<'2016-01-01' then endtime
            else offtime end as offtime
        from (
            select showid, bsshowid, name, starttime, case when endtime<starttime then starttime else coalesce(endtime,starttime) end as endtime, isthrough, showtype, showseattype, editstatus, createtime, performanceid, offtime, originthroughtime from origindb.dp_myshow__s_show where 1=1
                and createtime<'$onlinedt'
            ) how 
        ) as sho
        left join (
            select
                ActivityShowID,
                max(TPSProjectShowID) TPSProjectShowID
            from origindb.dp_myshow__bs_activityshowmap where Status=1
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
            case when to_date(offtime)>'$now.date' then 1 
            when to_date(offtime)='$now.date' then 3
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
            select ProjectShowID, Name, StartTime, case when endtime<starttime then starttime else coalesce(endtime,starttime) end as endtime, IsThrough, ShowType, ShowSeatType, EditStatus, CreateTime, ProjectID, OriginThroughTime, Status, NULL OffSaleTime, NULL OnSaleTime from origindb.dp_myshow__tps_projectshow where 1=1
                and createtime>=date_sub('$onlinedt',1)
            ) pow
            left join (
            select ActivityShowID, TPSProjectShowID from origindb.dp_myshow__bs_activityshowmap where Status=1
                ) apm
            on apm.TPSProjectShowID=pow.ProjectShowID
            left join (
                select distinct
                    bsshowid
                from origindb.dp_myshow__s_show where 1=1
                    and createtime<'$onlinedt'
                ) sho
            on sho.bsshowid=apm.ActivityShowID
        where
            sho.bsshowid is null
        ) as sho
    ) how
##TargetDDL##
CREATE TABLE IF NOT EXISTS `$target.table`
(
`show_id` bigint COMMENT '融合场次ID-推荐使用',
`activity_show_id` bigint COMMENT '后台场次id',
`show_name` string COMMENT '场次名称',
`show_starttime` string COMMENT '场次开始时间',
`show_endtime` string COMMENT '场次结束时间',
`show_isthrough` int COMMENT '是否为通票场次',
`show_type` int COMMENT '场次类型 1:为单场票 2:为通票 3:为连票',
`show_seattype` int COMMENT '场次座位类型 0:非选座1:选座',
`editstatus` int COMMENT '0下架,1上架',
`show_createtime` string COMMENT '创建时间',
`performance_id` bigint COMMENT '融合演出ID-推荐使用',
`originthroughtime` string COMMENT '通票场次时间',
`show_offtime` string COMMENT '场次下架时间',
`show_online_flag` int COMMENT '1:在线,2:已结束,3:当日下架',
`show_ontime` string COMMENT '场次开售时间',
`showid` bigint COMMENT '场次ID-2018-11截止更新',
`projectshowid` bigint COMMENT '场次ID-2018-11前值不全'

)  COMMENT '演出场次维度表'
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as orc
