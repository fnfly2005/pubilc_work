#!/usr/bin/python
#coding:utf-8
##################################
'''
Path: 
Description: 
Date: 
Version: v1.0
'''
##################################
arr=[0,1,2,3,4,5,6,7,8,9,'A','B','C','D','E','F']

def toX(num,x):
    """10进制转至x进制"""
    ar=[]
    number=''
    if x == 16:
        aop = 15
        bop = 4
    elif x == 8:
        aop = 7
        bop = 3
    elif x == 2:
        aop = 1
        bop = 1
    while num > 0:
        ar.append(arr[num & aop])
        num = num >> bop
    for a in range(len(ar)-1,-1,-1):
        number += str(ar[a])
    print number

def revRange(num):
    for a in range(num,-1,-1):
        print a

if __name__ == '__main__':
    toX(9,8)
