#!/usr/bin/python
#coding:utf-8
##################################
"""
Description: 内部类、局部内部类
Version: v1.0
"""
##################################

class Outer(object):
    def __init__(self):
        self.x = 4

    class Inner(object):
        def __init__(self):
            self.y = 5
            self.out = Outer() #调用外部类的实例变量或实例函数时，需先将外部类的实例传入内部类
            
        def show(self):
            z = 6
            print "show...innershowV" + str(z)#调用局部变量
            print "show...innerV" + str(self.y)#调用内部类实例变量
            print "show...outerV" + str(self.out.x)#调用外部类实例变量

    #返回一个局部内部类的实例
    def method(self):
        x = 10
        #继承内部类的局部内部类
        class InnerLocal(Outer.Inner): 
            print x

        il = InnerLocal()
        return il

if __name__ == '__main__':
    o = Outer()
    i = o.Inner()
    i.show()
    il = o.method()
    il.show()
