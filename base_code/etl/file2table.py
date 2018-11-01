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
'''
db = MySQLdb.connect(host='localhost',user='fnfly2005',passwd=sys.argv[1],db='upload_table',port=3306,charset='utf8')
cursor = db.cursor()
cursor.execute('drop table if exists sale_offline')
sql= """create table sale_offline (

   ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT=''"""

cursor.execute(sql)

db.close()
'''
def isnumber(s):
    try:
        float(s)
        if s.isdigit():
            return "int(11)"
        else:
            return "decimal(10,2)"
    except:
        return "varchar(20)"

print "create table sale_offline ("
with open(sys.argv[1],'rb') as upfile:
    upfile_list=upfile.readlines()
    field_list=upfile_list[0].strip().split(',')
    data_list=upfile_list[1].strip().split(',')
    d=0
    for f in field_list:
        print f + '\t' + isnumber(data_list[d]) + '\t' + "COMMENT ''"
        d = d + 1
print ") ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT=''"
