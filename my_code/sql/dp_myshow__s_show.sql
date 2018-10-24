/*场次信息表*/
select
    showid,
    bsshowid,
    name,
    starttime,
    case when endtime<starttime then starttime 
    else coalesce(endtime,starttime) end as endtime,
    isthrough,
    showtype,
    showseattype,
    editstatus,
    createtime,
    performanceid,
    offtime,
    originthroughtime
from 
    origindb.dp_myshow__s_show
where
    1=1
