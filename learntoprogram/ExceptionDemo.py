#!/usr/bin/python
#coding:utf-8
'''
Description:
异常处理，异常对象、自定义异常、异常捕捉、多异常捕捉、else、finally、异常转换封装
错误分为语法错误和异常
异常分为Exception和RuntimeError
Version: v1.0
'''
class LanPingError(Exception):
    pass 
        
class MaoYanError(Exception):
    pass 

class Computer(object):
    def __init__(self,state):
        self.state = state

    def run(self):
        if self.state == 1:
            raise LanPingError('Error..computer..lanping!!')
        elif self.state == 2:
            raise MaoYanError('Error..computer..maoyan!!')
        else:
            print "computer...run"
    
    def reset(self):
        self.state = 0
        print "computer...reset"

class NoPlanError(Exception):
    pass 

class Teacher(object):
    def __init__(self,name,comState):
       self.__name = name
       self.__comp = Computer(comState)

    def prelect(self):
        try:
            self.__comp.run()
        except LanPingError as e:
            print e.args
            self.__comp.reset()
            self.prelect()
        except MaoYanError as m:
            print m.args
            self.test()
            raise NoPlanError("Error...plan can't finish")
        else:
            print self.__name + "...teach"#else语句在try通过后未引发异常会执行

    def test(self):
        print "students...exercise"

if __name__ == '__main__':
    t = Teacher("fnfly2005",1)
    try:
        t.prelect()
    except NoPlanError as e:
        print e.args
        print ("change..people")
    finally:
        print "lesson...finish"
