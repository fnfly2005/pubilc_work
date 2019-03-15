#!/usr/bin/python
#coding:utf-8
"""
Description: 多线程之join线程序列
"""
import threading

class JoinRunDemo(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)

    def run(self):
        for x in range(50):
            print threading.currentThread().name + "..." + str(x)

if __name__ == '__main__':
    t1 = JoinRunDemo()
    t2 = JoinRunDemo()

    t1.start()
    t2.start()

    t1.join()#调用线程(main)需等待该线程(t1)完成才能继续运行

    for i in range(50):
        print threading.currentThread().name + "..." + str(i)
