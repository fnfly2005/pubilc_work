#!/usr/bin/python
#coding:utf-8
##################################
'''
Path: 
Description: 自动建表并上传文件至数据库
Date: 
Version: v1.0
'''
##################################
import MySQLdb
import sys
import re
def ConMysql(*args):
    db = MySQLdb.connect(host='127.0.0.1',user='fnfly2005',passwd=args[2],db='upload_table',port=3306,charset='utf8')
    cursor = db.cursor()
    cursor.execute("DROP TABLE IF EXISTS " + args[1])
    with open(args[0]) as sqlfile:
        sql = sqlfile.read()
    cursor.execute(sql)
    db.close()

def isnumber(s):
    try:
        float(s)
        if s.isdigit():
            return "int(11)"
        else:
            return "decimal(10,2)"
    except:
        return "varchar(20)"

def CreTabSql(*args):
    print "create table " + args[1] + " ("
    if args[2] == ',':
        sli = ','
    else:
        sli = '\t'
    with open(args[0],'rb') as upfile:
        upfile_list=upfile.readlines()
        field_list=upfile_list[0].strip().split(sli)
        data_list=upfile_list[1].strip().split(sli)
        d = 0
        dl = len(field_list) -1
        for f in field_list:
            if d < dl:
                ed=","
            else:
                ed=") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=''"
            print f + '\t' + isnumber(data_list[d]) + '\t' + "COMMENT ''" + ed
            d = d + 1

def helpinfo(*args):
    print """当参数1=c时,根据输入文件生成建表语句:参数2为输入文件,参数3为表名,参数4为分隔符
    当参数1=m时,根据输入SQL文件建表:参数2为输入文件,参数3为表名,参数4为密码
    当参数1=i时,从输入文件导入数据至指定表:参数2为输入文件,参数3为表名,参数4为密码"""

'''
字典映射替代分支
try:
    s0=sys.argv[1]
    s1=sys.argv[2]
    s2=sys.argv[3]
    s3=sys.argv[4]
except:
    s0='h'
    s1=0
    s2=s1
    s3=s1

functions = {
    'h': helpinfo,
    'c': CreTabSql,
    'm': ConMysql
    }
functions[s0](s1,s2,s3)
'''
if sys.argv[1] == 'c':
    CreTabSql(sys.argv[2],sys.argv[3],sys.argv[4])
elif sys.argv[1] == 'm':
    ConMysql(sys.argv[2],sys.argv[3],sys.argv[4])
else:
    helpinfo()
