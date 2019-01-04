#!/usr/bin/python
#coding:utf-8
'''
Description:单例模式之懒汉式-线程不安全
Version: v1.0
'''

class Single:
    '''单例模式示例'''
    def __init__(self):
        pass
    
    '''开放一个对外方法并返回对象'''
    @classmethod #表示该方法无需实例化
    def getInstance(cls):
        if not hasattr(Single,'ins'):#用于判断对象是否包含对应的属性 
            Single.ins=Single()
        return Single.ins

if __name__== '__main__':
    s1 = Single.getInstance()
    s2 = Single.getInstance()

    print s1
    print s2
