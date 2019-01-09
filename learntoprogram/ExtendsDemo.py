#!/usr/bin/python
#coding:utf-8
'''
Description:继承
Version: v1.0
'''
class Persion():

    def __init__(self):
        self.age = 20
        self.name = 'fnfly2005'
        print "哇哇"

    def show(self):
        print str(self.age) + "..fu.." + str(self.age)

class Student(Persion):
    #覆盖父类构造函数
    def __init__(self):
        Persion.__init__(self)#调用父类构造函数
        self.age = 10#会覆盖父类同名属性

    def show(self):
        Persion.show(self)#调用父类方法
        print str(self.age) + "..zi.." + str(self.age)#新增扩展功能

    def study(self):
        print self.name + "....student study"#调用父类属性,已在构造函数中初始化

class Worker(Persion):
    #子类没有构造函数，将继承父类的构造函数
    def work(self):
       print self.name +"....worker work"

if __name__ == '__main__':
    s=Student()
    s.show()
    s.study()
    w=Worker()
    w.show()
    w.work()
