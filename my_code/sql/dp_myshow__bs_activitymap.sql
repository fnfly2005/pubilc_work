/*演出项目商品匹配表*/
select
    ActivityID,
    TPSProjectID
from
    origindb.dp_myshow__bs_activitymap
where
    status=1
