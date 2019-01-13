#!/usr/bin/python
#coding:utf-8
'''
Description:抽象类和多继承-不推荐,无需接口来进行多实现 对程序员、经理、雇员、公司进行数据建模
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

class Learning(object):
    def read(self):
        pass

    def test(self):
        pass

#实现多继承或多实现
class Programmer(Employee,Learning):
    #使用父类构造函数

    #必须覆盖父类抽象方法
    def work(self):
        print str(self.name) + "..code.."

    def read(self):
        print "read..somebook.."

    def test(self):
        print "write..run..code.."

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

class Ai(Learning):
    def read(self):
        print ("read..somedata..")

    def test(self):
        print ("training..")

if __name__ == '__main__':
   p = Programmer("fnfly2005","001",10000)
   m = Manager("fnfly2005","002",20000,5000)
   a = Ai()
   p.showInfo()
   p.work()
   p.read()
   p.test()

   a.read()
   a.test()

   m.showInfo()
   m.work()
