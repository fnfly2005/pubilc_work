#1.0优化输出方式,函数处理;2.0新增实时模版;3.0优化函数功能;4.0函数模块化
#!/bin/bash
#读取文件
downloadsql_file() {
    file=`echo $1 | sed "s/[a-z]*\.sh//g;s/.*\///g"`".sql"
}

#脚本输出
fuc() {
    file_all="/Users/fannian/Documents/doc/$2"$file

    echo "success!"

    if [ ${1}r == dr ];then
        echo $file_all
        fus > $file_all
    else
        fus
    fi
    }

#读取SQL
fun() {
    if [[ ${1} =~ \. ]];then
        fil=${1}
    else
        fil="${1}.sql"
    fi
    if [[ ${1} =~ my_code ]];then
        pdir="$CODE_HOME"
    elif [[ ${1} =~ / ]];then
        pdir="${CODE_HOME}my_code/"
    else
        pdir="${CODE_HOME}my_code/sql/"
    fi
    tmp=`cat ${pdir}${fil} | grep -iv "/\*"`
    if [ -n $2 ];then
        if [[ $2 =~ d ]];then
            tmp=`echo $tmp | sed 's/where.*//'`
        fi
        if [[ $2 =~ D ]];then
            tmp=`echo $tmp | sed 's/where.*/where /'`
        fi
        if [[ $2 =~ u ]];then
            tmp=`echo $tmp | sed 's/.*from/from/'`
        fi
        if [[ $2 =~ t ]];then
            tmp=`echo $tmp | sed "s/begindate/today{-1d}/g;s/enddate/today{-0d}/g"`
        fi
        if [[ $2 =~ m ]];then
            tmp=`echo $tmp | sed "s/begindate/monthfirst{-1m}/g;s/enddate/monthfirst/g"`
        fi
        if [[ $2 =~ s ]];then
            tmp=`echo $tmp | sed "s/-time1/$3/g;s/-time2/$4/g"`
        fi
    fi
    echo $tmp
}


#按月偏移日期
diffmonth() {
    echo "substr(date_add('month',-\$month,date_parse('${2-\$\$today}','%Y-%m-%d')),1,${1-7})"
}

#偏移月份where条件
diffmonth_condition() {
    echo "substr($1,1,7)=`diffmonth`"
}

#自定义维度函数
cas() {
    echo "case when $1 in (\$dim) then $2 else ${3-'all'} end"
}
