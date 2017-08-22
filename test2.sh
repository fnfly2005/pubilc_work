#!/bin/bash
source ~/.bashrc
source ~/.bash_profile
source /etc/profile
export LANG="en_US.UTF-8"
export PATH="/opt/hbase/bin:/usr/java/jdk/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/hadoop/bin:/opt/hive/bin:/opt/sqoop/bin:/opt/zookeeper/bin:/usr/java/scala/bin:/opt/spark/bin:/opt/flume/bin:/usr/local/bin:/home/fannian/bin"
export CLASSPATH="/etc/hadoop/conf:/opt/hadoop-2.6.0-cdh5.4.8/share/hadoop/common/lib/*:/opt/hadoop-2.6.0-cdh5.4.8/share/hadoop/common/*:/opt/hadoop-2.6.0-cdh5.4.8/share/hadoop/hdfs:/opt/hadoop-2.6.0-cdh5.4.8/share/hadoop/hdfs/lib/*:/opt/hadoop-2.6.0-cdh5.4.8/share/hadoop/hdfs/*:/opt/hadoop-2.6.0-cdh5.4.8/share/hadoop/yarn/lib/*:/opt/hadoop-2.6.0-cdh5.4.8/share/hadoop/yarn/*:/opt/hadoop-2.6.0-cdh5.4.8/share/hadoop/mapreduce/lib/*:/opt/hadoop-2.6.0-cdh5.4.8/share/hadoop/mapreduce/*:/opt/hadoop/contrib/capacity-scheduler/*.jar:/opt/hadoop-2.6.0-cdh5.4.8/share/hadoop/tools/lib/commons-lang-2.6.jar"
export TERM="xterm"
export PWD="/data/fannian"
export EDITOR="vim"
export HDFS_INCLUDE_DIR="/opt/hadoop/include"
export HDFS_LIBS="/opt/hadoop/lib/native/libhdfs.so"
export HDFS_LIB_PATHS="/opt/hadoop/lib/native"
export YARN_LOG_DIR="/disk/hadoop/logs"
ph="/data/fannian/"
echo 10000 |awk '{printf "%'"'"'18.0f\n",$0}'|sed 's/ //g'>${ph}test6.txt
export>${ph}test5.log
