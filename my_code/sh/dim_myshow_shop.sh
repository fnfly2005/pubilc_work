#!/bin/bash
sql_name="演出场馆维度表"
source ${CODE_HOME-./}/my_code/fuc.sh
source ${CODE_HOME-./}/my_code/fet.sh
downloadsql_file $0 e
fus() {
echo "
`task origindb ${fil}`
$ins
select
    nuc.venue_id,
    nuc.shop_id,
    `coa shop_name dp_shop_name`,
    `coa address dp_shop_address`,
    `coa city_id dp_city_id`,
    `coa city_name dp_city_name`,
    nuc.status,
    `coa shop_createtime create_time`,
    nuc.updatetime,
    nuc.protectstatus,
    nuc.topstatus,
    nuc.audittime,
    nuc.applytime,
    nuc.bd_id,
    nuc.audituserid,
    nuc.bd_name,
    nuc.auditusername,
    nuc.branchname,
    nuc.mtshopid,
    longitude,
    latitude,
    $etl_time
from (
    select
        coalesce(nue.venueid,nce.dpshopid) as venue_id,
        coalesce(nue.dpshopid,nce.dpshopid) as shop_id,
        nue.name as shop_name,
        nue.address,
        nue.cityid as city_id,
        nue.cityname as city_name,
        nue.status,
        nue.createtime as shop_createtime,
        nue.updatetime,
        nue.protectstatus,
        nue.topstatus,
        nue.audittime,
        nue.applytime,
        nue.bduserid as bd_id,
        nue.audituserid,
        nue.bdusername as bd_name,
        nue.auditusername,
        nue.branchname,
        nue.mtshopid
    from 
        origindb.dp_myshow__t_venue nue
        full join (
            select distinct
                shopid as dpshopid
            `fun my_code/sql/dp_myshow__s_performance.sql u`
                and cityid<>4432
                and shopid<>0
            union
            select distinct
                dpshopid
            `fun my_code/sql/dp_myshow__tps_project.sql u`
                and cityid<>4432
                and dpshopid<>0
            ) as nce
        on nce.dpshopid=nue.dpshopid
    ) as nuc
    left join dw.dim_dp_shop dds
    on dds.dp_shop_id=nuc.shop_id
$cre
\`venue_id\` bigint COMMENT '主键',
\`shop_id\` bigint COMMENT '点评场馆ID',
\`shop_name\` string COMMENT '场馆名称',
\`address\` string COMMENT '场馆地址',
\`city_id\` bigint COMMENT '城市ID',
\`city_name\` string COMMENT '城市名字',
\`status\` int COMMENT '状态',
\`shop_createtime\` string COMMENT '创建时间',
\`updatetime\` string COMMENT '更新时间',
\`protectstatus\` int COMMENT '是否保护POI 1保护',
\`topstatus\` int COMMENT '置顶状态1不置顶2申请置顶3置顶',
\`audittime\` string COMMENT '审核时间',
\`applytime\` string COMMENT '申请时间',
\`bd_id\` bigint COMMENT '申请人ID',
\`audituserid\` bigint COMMENT '审核人ID',
\`bd_name\` string COMMENT '申请人名称',
\`auditusername\` string COMMENT '审核人姓名',
\`branchname\` string COMMENT '分店名称',
\`mtshopid\` bigint COMMENT '美团场馆ID',
\`longitude\` double COMMENT '经度',
\`latitude\` double COMMENT '纬度',
\`etl_time\` string COMMENT '更新时间'
`com`"
}

fuc $1 etl
