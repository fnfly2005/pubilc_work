/*演出页面流量宽表*/
select
    custom,
    event_id,
    event_attribute,
    page_identifier
from
    mart_movie.detail_myshow_mv_wide_report
where
    partition_date>='$$begindate'
    and partition_date>='$$enddate'
