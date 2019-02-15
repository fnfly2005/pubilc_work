#!/usr/bin/python
#coding:utf-8
"""
Description: 多线程技术
应用场景：由于有全局锁的存在，并不能利用多核优势
如果是CPU密集型，那多线程并不能带来效率上的提升，相反还可能会因为线程的频繁切换，导致效率下降
如果是IO密集型如爬虫，多线程进程可以利用IO阻塞等待时的空闲时间执行其他线程，提升效率

多线程应用一：继承threading.Thread并覆盖run方法
线程名称的获取和修改
多线程应用二：函数式-传递函数给thread
"""
import threading

class ThreadMain(threading.Thread):
    def __init__(self,name):
        threading.Thread.__init__(self,name=name) #调用父类构造函数并定义线程名

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
    print threading.currentThread().name
