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

db = MySQLdb.connect(host='localhost',user='fnfly2005',passwd=sys.argv[1],db='upload_table',port=3306,charset='utf8')
cursor = db.cursor()
cursor.execute('drop table if exists sale_offline')
sql= """create table sale_offline (

   )"""

cursor.execute(sql)

db.close()
