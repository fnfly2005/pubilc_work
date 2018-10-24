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
$ins
select
    ${fie}
    offtime,
    case when editstatus=1 then 
        case when to_date(offtime)>'\$now.date' then 1 
        when to_date(offtime)='\$now.date' then 3
        else 2 end
    else 2 end as show_online_flag
from (
    select 
        ${fie}
        case when offtime<'2016-01-01' then endtime
        else offtime end as offtime
    from (
        `fun my_code/sql/dp_myshow__s_show.sql`
        ) how 
    ) as sho
union all
`fun my_code/sql/dp_myshow__bs_activityshowmap.sql`
$cre
\`show_id\` bigint COMMENT '场次ID',
\`activity_show_id\` bigint COMMENT '后台场次id',
\`show_name\` string COMMENT '场次名称',
\`show_starttime\` string COMMENT '场次开始时间',
\`show_endtime\` string COMMENT '场次结束时间',
\`show_isthrough\` int COMMENT '是否为通票场次',
\`show_type\` int COMMENT '场次类型 1:为单场票 2:为通票 3:为连票',
\`show_seattype\` int COMMENT '场次座位类型 0:非选座1:选座',
\`editstatus\` int COMMENT '0下架,1上架',
\`show_createtime\` string COMMENT '创建时间',
\`performance_id\` bigint COMMENT '演出ID',
\`originthroughtime\` string COMMENT '通票场次时间',
\`show_online_flag\` int COMMENT '1:在线,2:已结束,3:当日下架',
\`show_offtime\` string COMMENT '场次下架时间',
\`show_ontime\` string COMMENT '场次开售时间'
`com`"
}

fuc $1 etl
