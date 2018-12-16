#!/usr/bin/python
#coding:utf-8
##################################
"""
Description: 函数
Version: v1.0
"""
##################################
def draw(row,col):
    """根据输入的行列数，在屏幕上输出一个矩形"""
    for c in range(row):
        print "*"*col

def equals(number):
    """根据考试成绩返回学生分数对应的等级"""
    if number in range(90,101):
        level = 'A'
    elif number in range(80,90):
        level = 'B'
    elif number in range(70,80):
        level = 'C'
    elif number in range(60,70):
        level = 'D'
    else:
        level = 'E'
    return level

def parrot(voltage,state='a stiff',action='voom'):
    """根据键值对输入，生成输出"""
    print "-- This parrot wouldn't", action,
    print "if you put", voltage, "volts through it.",
    print "E's", state, "!"

def write_multiple_items(*args):
    """打印所有输入值"""
    for a in args:
        print a

if __name__ == '__main__':
    draw(3,2)
    print equals(76)
    d = {"voltage": "four million", "state": "bleedin' demised"}
    parrot(**d)
    write_multiple_items("a",1,6546,"kill them")
