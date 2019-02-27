#!/usr/bin/python
#coding:utf-8
'''
Description:单例模式、装饰器
Version: v1.0
'''

def singleton(cls):
    instances = {}
    def getInstance(*args,**kw):
        if cls not in instances:
            instances[cls] = cls(*args,**kw)
        return instances[cls]
    return getInstance
    
@singleton
class Single(object):
    x = 100
    def __init__(self):
        pass

if __name__== '__main__':
    print Single()
    print Single()
