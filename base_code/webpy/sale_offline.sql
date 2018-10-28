create table todo (
    `sale_id` bigint COMMENT '分销单ID',
    `performance_name` string COMMENT '项目名称',
    `performance_id` bigint COMMENT '项目ID',
    `totalprice` double COMMENT '销售金额',
    `ticket_num` double COMMENT '出票量',
    `distributor` string COMMENT '分销商',
    `dt` string COMMENT '打款日期',
    `pay_type` string COMMENT '打款类型',
    `bd_name` string COMMENT '负责BD',
    `takerate` float COMMENT '佣金率-我司收入',
    `myorderid` bigint COMMENT '订单ID',
    `create_date` string COMMENT '创建日期')
COMMENT '线下分销流水表'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY 't'
