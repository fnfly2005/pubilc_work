#!/usr/bin/python
#coding:utf-8
"""
Description: 
"""
class PackageDemoA(object):
    def show(self):
        print "Hello PackageDemoA!!"

    def run(self):
        print "PackageDemoA run!!"

if __name__ == '__main__':
    p = PackageDemoA()
    p.show()
    p.run()
