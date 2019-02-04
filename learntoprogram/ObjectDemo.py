#!/usr/bin/python
#coding:utf-8
##################################
"""
Description: 魔术方法
__str__ __repr__ __cmp__ id __class__.__name__
Version: v1.0
"""
##################################
class PersionObject(object):
    def __init__(self,name,age):
        self.name=name
        self.age=age

    '''
    __str__对应于java中的toString方法,面向用户-print后显示值
    __repr__面向程序员-实际返回值
    id函数对应于java中的hashcode方法，返回对象标识的内存地址，a=b等价于id(a)=id(b)
    '''
    def __str__(self): 
        return "name:" + self.name + "   age:"+str(self.age) + " in " + str(hex(id(self)))
    __repr__=__str__

    '''
    __cmp__对应于java中的equals
    重写cmp函数实现自定义属性比较
    '''
    def __cmp__(self,s):
        if self.age > s.age:
            return 1
        elif self.age < s.age:
            return -1
        else: 
            return 0

if __name__ == '__main__':
    p1=PersionObject('fnfly2005',20)
    p2=PersionObject('fnfly2003',21)
    p3=PersionObject('fnfly2006',31)

    L = [p1,p2,p3]
    print str(sorted(L))+"##cmp比较函数适用于sorted"
    print str(p1 < p2) +"##自定义——比较属性age的大小"

    print p1.__class__.__name__ + "##对应于java中的getclass,返回类名"
