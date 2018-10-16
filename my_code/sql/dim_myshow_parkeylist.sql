/*非演出流量业务参数键值*/
select
    par_key,
    is_myshow,
    biz_tag,
    tag_name
from 
    upload_table.dim_myshow_parkeylist
