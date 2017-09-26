#!/bin/bash
presto_e="/opt/presto/bin/presto --server hc:9980 --catalog hive --execute "
hive_e="/opt/hive/bin/hive -e "
data="/data/fannian/data.csv"
tdt=`date -d "today" +"%d%H%M"`

table=${2:-tmp.t_${tdt}}
echo ${table}

if [ -z ${1} ]
then
${presto_e}"desc ${table};"
elif [ "c" = ${1} ]
then
${hive_e}"
create table ${table}(
		brand string COMMENT 'null',
		sub_brand string COMMENT 'null',
		sku_code string COMMENT 'null'
		)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ','
stored as textfile;
load data local inpath '${data}' into table ${table};"
elif [ "d" = ${1} ]
then
${hive_e}"drop table ${table};"
elif [ "p" = ${1} ]
then
${hive_e}"
create table ${table}(
		id string COMMENT 'null',
		key string COMMENT 'null'
		)
partitioned by(dt string)
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',';"
else
exit 0
fi
