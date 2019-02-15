#!/usr/bin/python
#coding:utf-8
"""
Description: 变量&运算符
"""

def show():
    x,y = 5,2
    x /= y
    print x

    x = 5 % y
    print x

    print (x == 0 and y ==2)

    z = 100 if x > y else 200
    print z

if __name__=='__main__':
    show()
