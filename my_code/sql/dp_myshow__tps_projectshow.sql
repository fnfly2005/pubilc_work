/*第三方场次*/
select
    ProjectShowID,
    Name,
    StartTime,
    case when endtime<starttime then starttime 
    else coalesce(endtime,starttime) end as endtime,
    IsThrough,
    ShowType,
    ShowSeatType,
    EditStatus,
    CreateTime,
    ProjectID,
    OriginThroughTime,
    Status,
    NULL OffSaleTime,
    NULL OnSaleTime
from 
    origindb.dp_myshow__tps_projectshow
where
    1=1
