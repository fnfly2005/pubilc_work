

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
    'table': 'dim_myshow_project', 
} 
##Extract##

##Preload##

##Load##
insert OVERWRITE TABLE `$target.table`
select
    projectid as project_id,
    tpid as customer_id,
    cityid as city_id,
    categoryid as category_id,
    tpprojectid,
    projectvenueid,
    name as project_name,
    posterurl,
    seaturl,
    brief,
    detail,
    performer,
    keywords,
    tpprojectjson,
    status,
    createtime as project_createtime,
    updatetime,
    contractid as contract_id,
    dpshopid as shop_id,
    squareposterurl,
    shortname as project_shortname,
    needrealname,
    maxbuylimitperid,
    maxbuylimitperorder,
    minbuylimitperorder,
    maxorderlimitperuser,
    buyinstruction,
    bduserid as bd_userid,
    bdname as bd_name,
    insteaddelivery,
    chargesrate,
    editstatus,
    needticket,
    needseat,
    independent,
    projectticketstatus,
    reviewer,
    projectreviewstatus,
    projectreviewreasontype,
    stockoutregister,
    maxbuylimitperuser,
    performanceid as performance_id,
    activityid as activity_id
from (
    select
        *
    from origindb.dp_myshow__tps_project where 1=1
    ) as ect
    left join (
        select ActivityID, TPSProjectID from origindb.dp_myshow__bs_activitymap where status=1
        ) as yap
    on yap.TPSProjectID=ect.projectid
    left join (
        select
            bsperformanceid,
            max(PerformanceID) performanceid
        from origindb.dp_myshow__s_performance where 1=1
        group by
            1
        ) per
    on per.bsperformanceid=yap.ActivityID
##TargetDDL##
CREATE TABLE IF NOT EXISTS `$target.table`
(
`project_id` bigint COMMENT '商品ID',
`customer_id` bigint COMMENT '第三方ID/客户ID',
`city_id` bigint COMMENT '城市ID',
`category_id` bigint COMMENT '类目ID',
`tpprojectid` string COMMENT '第三方演出ID',
`projectvenueid` bigint COMMENT '第三方场馆ID',
`project_name` string COMMENT '演出名称',
`posterurl` string COMMENT '海报图',
`seaturl` string COMMENT '座位图',
`brief` string COMMENT '摘要',
`detail` string COMMENT '详情',
`performer` string COMMENT '演员',
`keywords` string COMMENT '关键词',
`tpprojectjson` string COMMENT '第三方演出原始json',
`status` int COMMENT '状态，0：无效 1：有效 2：禁用',
`project_createtime` string COMMENT '创建时间',
`updatetime` string COMMENT '更新时间',
`contract_id` string COMMENT '合同ID',
`shop_id` bigint COMMENT '点评商户（场馆）ID',
`squareposterurl` string COMMENT '方图',
`project_shortname` string COMMENT '短标题',
`needrealname` int COMMENT '是否实名制购票',
`maxbuylimitperid` bigint COMMENT '每个有效证件最大购买份数',
`maxbuylimitperorder` bigint COMMENT '每笔订单最大购买份数',
`minbuylimitperorder` bigint COMMENT '每笔订单最小购买份数',
`maxorderlimitperuser` bigint COMMENT '每个用户最大购买订单数',
`buyinstruction` string COMMENT '购票须知',
`bd_userid` bigint COMMENT '销售用户id',
`bd_name` string COMMENT '销售姓名',
`insteaddelivery` int COMMENT '猫眼代发货字段，0 非代发货 ，1代发货',
`chargesrate` double COMMENT '佣金比例',
`editstatus` bigint COMMENT '商品编辑状态0:不需要编辑，1：未编辑，2：已编辑',
`needticket` int COMMENT '是否需要打票 0不是 1是',
`needseat` int COMMENT '是否选座项目 0不是 1是',
`independent` int COMMENT '是否独立',
`projectticketstatus` int COMMENT '商品售卖状态',
`reviewer` bigint COMMENT '审核人',
`projectreviewstatus` int COMMENT '审核状态',
`projectreviewreasontype` int COMMENT '审核原因类型',
`stockoutregister` int COMMENT '是否缺货登记项目 0不是 1是',
`maxbuylimitperuser` bigint COMMENT '每个用户最大购买量',
`performance_id` bigint COMMENT '项目ID',
`activity_id` bigint COMMENT '后台项目ID'

)  COMMENT '演出商品维度表'
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY '\t'
stored as orc
