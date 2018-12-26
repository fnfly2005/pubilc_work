#!/usr/bin/python
#coding:utf-8
##################################
"""
Description:数组&类
Version: v1.0
"""
##################################
ar = [12,443,32,5,500,27,200,64]

class array:
    """用于处理数组对象"""
    dt = 5 #类变量，各实例对象共享

    def __init__(self,arr=[]):
        """构造函数，用于初始化数组对象,并封装变量"""
        if arr == []:
            self.__data = ar #实例变量，各实例私有
        else:
            self.__data = arr

    def setData(self,arr):
        """修改数据值"""
        self.__data = arr

    def getData(self):
        """获取数据值"""
        return self.__data

    def rangeArray(self):
        """迭代打印数组"""
        print "[",
        for i,r in enumerate(self.__data):
            print r,
            if i < len(self.__data)-1:
                print ',',
        print "]"

    def filterAr(self,v):
        """判断输入值是否是指定数组元素的约数，生成是或否的新数组"""
        newar = []
        for a in self.__data:
            if a % v == 0:
                newar.append(str(v) + '是')
            else:
                newar.append(str(v) + '不是')
        return newar

    def maximum(self):
        """遍历数组并查找数组中最大值"""
        max = 0
        for a in range(1,len(self.__data)):
            if self.__data[a] > self.__data[max]:
                max = a
        return max

    def __swap(self,array,a1,a2):
        """双下划线私有化方法，实现数组中两个值的位置互换"""
        temp = array[a1]
        array[a1] = array[a2]
        array[a2] = temp

    def selectSort(self):
        """通过选择排序算法实现顺序排列"""
        for a in range(len(self.__data)-1):
            for x in range(a+1,len(self.__data)):
                if self.__data[a] > self.__data[x]:
                    self.__swap(self.__data,a,x)

    def bubbleSort(self):
        """通过冒泡排序算法实现顺序排列"""
        for a in range(1,len(self.__data)):
            for x in range(len(self.__data)-a):
                if self.__data[x] > self.__data[x+1]:
                    self.__swap(self.__data,x,x+1)

    def bubbleSortPro(self):
        """通过冒泡排序算法实现顺序排列,利用中间变量提高性能"""
        for a in range(len(self.__data)-1):
            tmp = self.__data[0]
            tp = 0
            for x in range(1,len(self.__data)-a):
                if self.__data[x] > tmp:
                    tmp = self.__data[x]
                    tp = x
            self.__swap(self.__data,tp,x)

    def search(self,v):
        """在指定数组中循环查找给定值,并返回值所在角标"""
        for i,a in enumerate(self.__data):
            if v == a:
                return i
        else:
            return -1

    def binarySearch(self,v):
        """在指定数组中通过折半查找算法查找给定值,并返回值所在角标"""
        bubbleSortPro(self.__data)
        low = 0
        high = len(self.__data)-1
        while low <= high:
            mid = (low + high)/2
            if self.__data[mid] == v:
                return mid
            elif self.__data[mid] > v:
               high = mid - 1
            else:
               low = mid + 1
        return -1

def arrayZip(arx,ary):
    """根据两对数组的值,匹配打印判断语句"""
    for x, y in zip(arx, ary):
        print '{0} {1} 的约数'.format(x,y)

if __name__ == '__main__':
    a = array()
    a.rangeArray()
    a.bubbleSort()
    a.rangeArray()
    print a.getData()
