#!/usr/bin/python
#coding:utf-8
"""
Description: 继承导入模块
"""
import PackageDemoA as pa
class PackageDemoB(pa.PackageDemoA):
    def run(self):
        print "PackageDemoB run!!"

if __name__ == '__main__':
    p = PackageDemoB()
    p.show()
    p.run()
