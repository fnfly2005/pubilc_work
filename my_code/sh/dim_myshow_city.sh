#!/bin/bash
sql_name="演出城市维度表"
source ${CODE_HOME-./}/my_code/fuc.sh
source ${CODE_HOME-./}/my_code/fet.sh
downloadsql_file $0 e

fus() {
echo "
`task origindb ${fil}`
$ins
select
    dc.cityid as city_id,
    dc.cityname as city_name,
    dc.provinceid as province_id,
    `coa province_name \'其他\'`,
    `coa area_1_level_id 0`,
    `coa area_1_level_name \'其他\'`,
    `coa area_2_level_id 0`,
    `coa area_2_level_name \'其他\'`,
    mcm.parentdpcity_id,
    mcm.parentdpcity_name,
    cms.mt_city_id,
    case when cms.mt_city_id is null or cms.mt_city_id=0 then 1
    else 0 end as dp_flag,
    `coa city_level 4`,
    $etl_time,
    cms.ad_code as region_code,
    ke.citykey
from
    origindb.dp_myshow__s_dpcitylist dc
    left join dw.dim_dp_mt_city_mapping_scd cms
    on cast(dc.cityid as bigint)=cms.dp_city_id
    and cms.is_enabled=1
    left join upload_table.dim_myshow_province_s as dp
    on dp.province_id=dc.provinceid
    left join upload_table.dim_myshow_citylevel cl
    on cl.mt_city_id=cms.mt_city_id
    left join upload_table.dim_myshow_dxcitymap mcm
    on mcm.mtcity_id=cms.mt_city_id
    left join upload_table.dim_myshow_dpcitykey ke
    on ke.dpcityid=dc.cityid
$cre
\`city_id\` bigint COMMENT '点评城市ID',
\`city_name\` string COMMENT '点评城市名称',
\`province_id\` int COMMENT '点评省份ID',
\`province_name\` string COMMENT '省份名称',
\`area_1_level_id\` int COMMENT '战区ID',
\`area_1_level_name\` string COMMENT '战区名称',
\`area_2_level_id\` int COMMENT '分区ID',
\`area_2_level_name\` string COMMENT '分区名称',
\`parentdpcity_id\` bigint COMMENT '点评父级城市ID,若无父级城市则为空',
\`parentdpcity_name\` string COMMENT '点评父级城市名称',
\`mt_city_id\` bigint COMMENT '美团城市ID',
\`dp_flag\` int COMMENT '点评专属城市标志 0:美团点评共有 1:点评专属',
\`city_level\` int COMMENT '猫眼城市等级',
\`etl_time\` string COMMENT '更新时间',
\`region_code\` bigint COMMENT '行政区编码',
\`citykey\` string COMMENT '城市关键词'
`com`"
}

fuc $1 etl
