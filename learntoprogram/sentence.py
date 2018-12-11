#!/usr/bin/python
#coding:utf-8
##################################
"""
Description:语句 
Version: v1.0
"""
##################################
weekar= ['一','二','三','四','五','六','日']
def weekCon(x):
    """if 语句判断星期"""
    if x in range(1,8):
        print "星期" + weekar[x-1]
    else:
        print "星期" + str(x) + "不存在"
    
def seasonCon(x):
    """if 语句判断季节"""
    if x in range(1,13):
        if x in (12,1,2):
            y = "冬"
        elif x in (3,4,5):
            y = "春"
        elif x in (6,7,8):
            y = "夏"
        elif x in (9,10,11):
            y = "秋"
        print str(x) + "月是" + y + "季"
    else:
        print str(x) + "月不存在"

if __name__ == '__main__':
    weekCon(7)
