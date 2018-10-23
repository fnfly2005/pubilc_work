#!/bin/bash
sql_name="数据质量调研_n对n验证"
source ${CODE_HOME-./}my_code/fuc.sh
fus() {
echo "
select
    case when b_num<2 then b_num
    else 2 end as b_num,
    count(distinct \$field_a) as a_num
from (
    select
        \$field_a,
        count(distinct \$field_b) b_num
    from 
        \$table_name
    where
        \$condition
        and \$time_cond>='\$\$begindate'
    group by
        1
    ) as a
group by
    1
${lim-;}"
}

downloadsql_file $0
fuc $1
