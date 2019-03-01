#!/usr/bin/python
#coding:utf-8
"""
Description: 多线程之死锁
"""
import threading
class DeadLock(object):
    def __init__(self):
        self.num = 0
        self.r = threading.Lock()
        self.t = threading.Lock()

    def show(self):
        while True:
            if self.num % 2 == 1:
                self.r.acquire()
                self.t.acquire()
                print self.num
                self.t.release()
                self.r.release()
            else:
                self.t.acquire()
                self.r.acquire()
                print self.num
                self.r.release()
                self.t.release()
            self.num = self.num + 1

class DeadLockDemo(threading.Thread):
    def __init__(self,DeadLock):
        threading.Thread.__init__(self)
        self.DeadLock=DeadLock

    def run(self):
        self.DeadLock.show()

if __name__ == '__main__':
   d = DeadLock()
   t1 = DeadLockDemo(d)
   t2 = DeadLockDemo(d)

   t1.start()
   t2.start()
