#!/usr/bin/python
#coding:utf-8
"""
Description: 多线程技术
多线程应用一：继承threading.Thread并覆盖run方法
线程名称的获取修改
多线程应用二：函数式-传递函数给thread
"""
from threading import Thread

class ThreadMain(Thread):
    def __init__(self,name):
        Thread.__init__(self,name=name) #调用父类构造函数并定义线程名

    def show(self):
        for x in range(10):
            print str(x)+" on "+self.getName()

    def run(self):
        self.show() #覆盖run方法

if __name__ == '__main__':
    d1 = ThreadMain("xiaoqiang") #建立一个线程对象
    d2 = ThreadMain("旺财")
    d1.start() #启动线程
    d2.start()
