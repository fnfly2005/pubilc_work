#!/usr/bin/python
#coding:utf-8
"""
Description: 多线程技术之经典生产者消费者问题
构建一个存放烤鸭的餐厅，用多线程技术实现厨师往餐厅里放烤鸭，客人从餐厅里取烤鸭
"""
import threading

class Restaurant(object):
    
    def __init__(self):
        self.count = 1
        self.flag = False
        self.con = threading.Condition()

    def putDuck(self,name):
        self.con.acquire()
        while self.flag:
            self.con.wait() #循环判断，防止线程不安全
        self.name = name + str(self.count)
        print threading.currentThread().name + " 生产 " + self.name
        self.count = self.count +1
        self.flag = True
        self.con.notifyAll() #唤醒所有线程
        self.con.release()

    def takeDuck(self):
        self.con.acquire()
        while not self.flag:
            self.con.wait()
        print threading.currentThread().name + " 消费 " + self.name
        self.flag = False 
        self.con.notifyAll()
        self.con.release()
            
class Cooker(threading.Thread):
    def __init__(self,r):
        threading.Thread.__init__(self)
        self.r = r

    def run(self):
        while True:
            self.r.putDuck("鸭子")

class Epicure(threading.Thread):
    def __init__(self,r):
        threading.Thread.__init__(self)
        self.r = r

    def run(self):
        while True:
            self.r.takeDuck()

if __name__ == '__main__':
    r = Restaurant()
    c1 = Cooker(r)
    c2 = Cooker(r)
    e1 = Epicure(r)
    e2 = Epicure(r)
    
    c1.start()
    c2.start()
    e1.start()
    e2.start()
