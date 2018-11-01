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
            print str(s) + "int(11)"
        else:
            print str(s) + "decimal(10,2)"
    except:
        print s + "varchar(20)"
        
with open(sys.argv[1],'rb') as upfile:
    upfile_list=upfile.readlines()
    field_list=upfile_list[0].strip().split(',')
    data_list=upfile_list[1].strip().split(',')
    for d in data_list:
        isnumber(d)
