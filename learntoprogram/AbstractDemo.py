#!/usr/bin/python
#coding:utf-8
'''
Description:抽象类 对程序员、经理、雇员、公司进行数据建模
Version: v1.0
'''
import abc

'''定义抽象类'''
class Employee(object):
    __metaclass__ = abc.ABCMeta #abc.ABCMeta 是一个metaclass，用于在Python程序中创建抽象基类。
    
    def __init__(self,name,id,pay):
       self.name = name
       self.id = id
       self.pay = pay

    @abc.abstractmethod #修饰抽象方法,子类若不覆盖则报错
    def work(self):pass

    def showInfo(self):
        print 'name is ' + str(self.name)
        print 'id is ' + str(self.id)
        print 'pay is ' + str(self.pay)

class Programmer(Employee):
    #使用父类构造函数

    #必须覆盖父类抽象方法
    def work(self):
        print str(self.name) + "..code.."

class Manager(Employee):
    #使用父类构造函数并添加新属性
    def __init__(self,name,id,pay,bonus):
        Employee.__init__(self,name,id,pay)
        self.bonus = bonus

    #必须覆盖父类抽象方法
    def work(self):
        print str(self.name) + "..manager.."

    def showInfo(self):
        Employee.showInfo(self)
        print 'bonus is ' + str(self.bonus)

if __name__ == '__main__':
   p = Programmer("fnfly2005","001",10000)
   m = Manager("fnfly2005","002",20000,5000)
   p.showInfo()
   p.work()
   m.showInfo()
   m.work()
