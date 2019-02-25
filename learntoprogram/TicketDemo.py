#!/usr/bin/python
#coding:utf-8
"""
Description: 多线程技术-线程数据共享及线程安全问题
同步锁-基本锁
"""
import time
import threading

class Ticket(object):
    def __init__(self,num):
        self.num = num
        self.r = threading.Lock()
    
    def show(self):
        while True:
            self.r.acquire()
            if self.num > 0:
                time.sleep(0.002)
                print threading.currentThread().name + "..sale.." + str(self.num)
            self.num -= 1
            self.r.release()

class TicketDemo(threading.Thread):
    def __init__(self,ticket):
        threading.Thread.__init__(self)
        self.ticket = ticket
        
    def run(self):
        self.ticket.show()

if __name__ == '__main__':
    t = Ticket(100)
    t1 = TicketDemo(t)
    t2 = TicketDemo(t)
    t3 = TicketDemo(t)
    t4 = TicketDemo(t)

    t1.start()
    t2.start()
    t3.start()
    t4.start()
