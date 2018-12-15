#!/usr/bin/python
#coding:utf-8
"""
Description:语句 
Version: v1.0
"""

def weekIf(x):
    """if 语句判断星期"""
    weekar= ['一','二','三','四','五','六','日']
    if x in range(1,8):
        print "星期" + weekar[x-1]
    else:
        print "星期" + str(x) + "不存在"
    
def seasonIf(x):
    """if 语句判断季节"""
    if x in (12,1,2):
        y = "冬"
    elif x in (3,4,5):
        y = "春"
    elif x in (6,7,8):
        y = "夏"
    elif x in (9,10,11):
        y = "秋"
    else:
        print str(x) + "月不存在"
        return
    print str(x) + "月是" + y + "季"

def multiplicationFor(x=9):
    """for 语句实现99乘法表"""
    for a in range(1,x+1):
        if a == 10:
            break#用break跳出循环,continue执行下一个循环
        for b in range(1,a+1):
            print str(b) + "*" + str(a) + "=" + str(b*a) + '\t',
        print '\n'

def multiplicationWhile(x=9):
    """while 语句实现99乘法表"""
    a = 1
    while a <= x:
        b = 1
        while b <= a:
            print str(b) + " * " + str(a) + " = " + str(b*a) + '\t',
            b += 1
        print '\n'
        a += 1

if __name__ == '__main__':
    multiplicationFor(10)
