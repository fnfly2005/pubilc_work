/*场次映射表*/
select
    ActivityShowID,
    TPSProjectShowID
from
    origindb.dp_myshow__bs_activityshowmap
where
    Status=1
