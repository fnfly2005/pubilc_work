##Description##
##TaskInfo##
creator = 'fannian@maoyan.com'
source = {
    'db': META['hdw'], 
}

stream = {
    'format': '',
}

target = {
    'db': META['hmart_movie'],
    'table': 'detail_myshow_orderattribution', 
}

##Load##
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.parallel=true;
set hive.exec.reducers.max =1000;
set mapreduce.reduce.memory.mb=4096;
set mapreduce.map.memory.mb=4096;
set mapred.child.java.opts=-Xmx3072m;
set hive.auto.convert.join=true;
set mapred.max.split.size=256000000;
set mapred.min.split.size.per.node=256000000;
set mapred.min.split.size.per.rack=256000000;
set hive.merge.size.per.task=256000000;
set hive.merge.smallfiles.avgsize=256000000;
set hive.merge.mapfiles=true;
set hive.merge.mapredfiles=true;
set hive.input.format=org.apache.hadoop.hive.ql.io.CombineHiveInputFormat;
INSERT OVERWRITE TABLE `$target.table` PARTITION (partition_date = '$now.date')
select
    app_name,
    event_id,
    geo_city_id,
    idfa,
    imei,
    ip_location_city_id,
    os,
    page_city_id,
    page_identifier,
    performance_id,
    refer_page_identifier,
    ort.sequence,
    session_id,
    stat_time,
    ord.union_id,
    user_id,
    uv_src,
    ord.order_id,
    item_index,
    geodpcity_id,
    pagedpcity_id,
    event_name_lv1,
    event_name_lv2,
    page_name_my,
    category_id,
    city_id,
    province_id,
    shop_id
from (
    select
        union_id,
        order_id,
        min(sequence) sequence
    from
        mart_movie.detail_myshow_mv_wide_report
    where
        order_id is not null
        and page_cat=3
        and partition_date = '$now.date'
    group by
        union_id,
        order_id
    ) as ord
    left join (
        select
            *
        from 
            mart_movie.detail_myshow_mv_wide_report
        where
            page_cat<=2
            and partition_date = '$now.date'
        ) as ort
    on ort.union_id=ord.union_id
    and ort.sequence<ord.sequence
;

##TargetDDL##
CREATE TABLE IF NOT EXISTS `$target.table`
(
`app_name` string COMMENT 'APP中文描述',
`event_id` string COMMENT '事件标识ID,bid',
`geo_city_id` bigint COMMENT 'geohash城市ID',
`idfa` string COMMENT 'idfa',
`imei` string COMMENT 'imei',
`ip_location_city_id` bigint COMMENT 'ip城市ID',
`os` string COMMENT 'os',
`page_city_id` bigint COMMENT '页面城市id',
`page_identifier` string COMMENT '页面cid',
`performance_id` bigint COMMENT '演出ID-项目ID',
`refer_page_identifier` string COMMENT 'refer_page_identifier',
`sequence` bigint COMMENT 'session内的事件序号(同一union_id，session内唯一)',
`session_id` string COMMENT 'session_id',
`stat_time` string COMMENT 'stat_time',
`union_id` string COMMENT '设备ID',
`user_id` bigint COMMENT '用户id',
`uv_src` string COMMENT '页面来源',
`order_id` string COMMENT 'order_id',
`item_index` bigint COMMENT '控件内的位置',
`geodpcity_id` bigint COMMENT '定位城市id-点评',
`pagedpcity_id` bigint COMMENT '页面城市id-点评',
`event_name_lv1` string COMMENT '一级模块名',
`event_name_lv2` string COMMENT '二级模块名',
`page_name_my` string COMMENT '页面名称',
`category_id` bigint COMMENT '类别ID',
`city_id` bigint COMMENT '项目城市ID',
`province_id` bigint COMMENT '项目省份ID',
`shop_id` bigint COMMENT '点评场馆ID'
) COMMENT '演出页面流量宽表'
PARTITIONED BY (
    partition_date    string  COMMENT '日志生成日期'
) STORED AS ORC;
