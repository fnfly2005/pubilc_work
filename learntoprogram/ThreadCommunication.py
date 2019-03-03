#!/usr/bin/python
#coding:utf-8
"""
Description: 线程间通信技术
threading.Condition()对象除同步锁外，提供额外的等待和唤醒方法
"""
import threading

class Resource(object):
    def __init__(self):
        self.flag = False
        self.con = threading.Condition()

    def setArt(self,name,sex):
        self.con.acquire()
        if self.flag:
            self.con.wait()
        self.name = name
        self.sex = sex
        self.flag = True
        self.con.notify()
        self.con.release()

    def showArt(self):
        self.con.acquire()
        if not self.flag:
            self.con.wait()
        print self.name + " is " + self.sex
        self.flag = False
        self.con.notify()
        self.con.release()

class SetResource(threading.Thread):
    def __init__(self,r):
        threading.Thread.__init__(self)
        self.r = r

    def run(self):
        x = 0
        while True:
            if x == 0:
                self.r.setArt("mike","male")
            else:
                self.r.setArt("莉莉","女")
            x = (x+1)%2

class ShowResource(threading.Thread):
    def __init__(self,r):
        threading.Thread.__init__(self)
        self.r = r

    def run(self):
        while True:
            self.r.showArt()

if __name__ == '__main__':
    r = Resource()
    st = SetResource(r)
    sw = ShowResource(r)

    st.start()
    sw.start()
