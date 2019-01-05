#!/usr/bin/python
#coding:utf-8
'''
Description:单例模式
Version: v1.0
'''

'''单例模式-线程不安全,继承object成为新式类,按广度优先原则搜索方法和变量
-区别于无需继承的经典类,按深度优先原则搜索方法和变量'''
class SingleLazy(object):
    __ins = None

    '''new方法是创建类实例的方法，需要从object里继承
    不能使用__init__ 因为__init__在实例生成后使用'''
    def __new__(cls):
        if cls.__ins is None:
            cls.__ins=super(SingleLazy,cls).__new__(cls)
        return cls.__ins

if __name__== '__main__':
    s1 = SingleLazy()
    s2 = SingleLazy()

    print s1
    print s2
