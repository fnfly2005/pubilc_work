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
def ConMysql(sqlfiles,Tablename,mysqlpw):
    db = MySQLdb.connect(host='localhost',user='fnfly2005',passwd=mysqlpw,db='upload_table',port=3306,charset='utf8')
    cursor = db.cursor()
    cursor.execute("DROP TABLE IF EXISTS " + Tablename)
    with open(sqlfiles) as sqlfile:
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

def CreTabSql(Files,Tablename):
    print "create table " + Tablename + " ("
    with open(Files,'rb') as upfile:
        upfile_list=upfile.readlines()
        field_list=upfile_list[0].strip().split(',')
        data_list=upfile_list[1].strip().split(',')
        d = 0
        dl = len(field_list) -1
        for f in field_list:
            if d < dl:
                ed=","
            else:
                ed=") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=''"
            print f + '\t' + isnumber(data_list[d]) + '\t' + "COMMENT ''" + ed
            d = d + 1

desc="""当参数1=c时：根据输入文件生成建表语句 参数2为输入文件 参数3为表名
当参数2=m时：根据输入SQL文件建表 参数2位输入文件 参数3为表名，参数4为mysql密码"""
#try:
if sys.argv[1] == 'c':
    CreTabSql(sys.argv[2],sys.argv[3])
elif sys.argv[1] == 'm':
    ConMysql(sys.argv[2],sys.argv[3],sys.argv[4])
else:
    print desc
#except:
    #print desc
