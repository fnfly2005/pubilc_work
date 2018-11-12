#!/usr/bin/python
#coding:utf-8
##################################
'''
Path: 
Description: 根据数据文件生成SQL
Date: 
Version: v1.0
'''
##################################
import sys

def isnumber(s):
    try:
        float(s)
        if s.isdigit():
            return "int(11)"
        else:
            return "decimal(10,2)"
    except:
        return "varchar(20)"

def CreTabSql(src_file,spl_del):
    print "create table table_name ("
    if spl_del != ',':
        spl_del = '\t'
    with open(args[0],'rb') as upfile:
        upfile_list=upfile.readlines()
        field_list=upfile_list[0].strip().split(spl_del)
        data_list=upfile_list[1].strip().split(spl_del)
        d = 0
        dl = len(field_list) -1
        for f in field_list:
            if d < dl:
                ed=","
            else:
                ed=") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT=''"
            print f + '\t' + isnumber(data_list[d]) + '\t' + "COMMENT ''" + ed
            d = d + 1

if __name__ == '__main__':
    if sys.argv[1] == 'h':
        print "根据输入文件生成建表语句:参数1为输入文件,参数2分隔符"
    else:
        CreTabSql(sys.argv[1],sys.argv[2])
