#!/usr/bin/python
#coding:utf-8
##################################
'''
Path: 
Description: python操作mysql
Date: 
Version: v1.0
'''
##################################
import MySQLdb
import sys

def ConMysql(*args):
    db = MySQLdb.connect(host='127.0.0.1',user='fnfly2005',passwd=args[2],db='upload_table',port=3306,charset='utf8')
    cursor = db.cursor()
    with open(args[0]) as sqlfile:
        sql = sqlfile.read()
    cursor.execute(sql)
    db.close()

if __name__ == '__main__':
    ConMysql(sys.argv[1],sys.argv[2],sys.argv[3])
