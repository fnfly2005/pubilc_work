#!/bin/bash
sql_name="数据质量调研工具"
source ${CODE_HOME-./}my_code/fuc.sh

case_when () {
echo "case when $1 is null then $2 end"
}

fus() {
echo "
select
    count(distinct `case_when 'b.\$b_id' 'a.\$c_id'`) as a_num,
    count(distinct a.\$a_id) as a_cnum,
    count(distinct `case_when 'a.\$a_id' 'b.\$b_id'`) as b_num,
    count(distinct b.\$b_id) as b_cnum,
    count(distinct case when a.\$a_id is not null and b.\$b_id is not null then a.\$a_id end) as ab_num
from
    \$table_a a
    full join \$table_b b
    on a.\$a_id=b.\$b_id
where
    a.\$aad_timea>='\$\$begindate'
    and a.\$aad_timea<='\$\$enddate'
    and b.\$aad_timeb>='\$\$begindate'
    and b.\$aad_timeb<='\$\$enddate'
${lim-;}"
}

downloadsql_file $0
fuc $1
