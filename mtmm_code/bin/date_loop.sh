#!/bin/bash
#日期SHELL-v5.2 参数说明(1.起始日期-start_date-SQL引用关键参数 2.结束时间-to_date-循环模式start_date递增至与其相等 3.脚本路径 4.间隔时间-interval_day-循环递增值及end_date与start_day差值 )
#示例 sh /data/fannian/bin/date_loop.sh "$1" "$2" "/data/fannian/test.sh" "$3"

if [ -z $1 ]
then
start_date=`date -d yesterday +%Y-%m-%d`
else
start_date=$1
fi

if [ -z $2 ]
then
to_date=`date -d "$start_date 0 days ago" +%Y-%m-%d`
else
to_date=$2
fi


if [ -z $4 ]
then
interval_day=1
else
interval_day=$4
fi


start_s=`date -d "$start_date" +%s`
to_s=`date -d "$to_date -1 days ago" +%s`
interval_s=60*60*24*$interval_day

while [ $start_s -lt $to_s ]
do
if [ -z $3 ]
then
echo "start_date:"$start_date
echo "to_date:"$to_date
echo "**********"
else
file_path=$3
bash $file_path $start_date
fi
let start_s=($start_s+$interval_s)
start_date=`date -d @$start_s +%Y-%m-%d`
done
