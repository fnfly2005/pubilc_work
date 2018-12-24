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
    "用于处理数组对象"
    def __init__(self,arr=[]):
        """构造函数，用于初始化数组对象"""
        self.data = arr

    def rangeArray(self):
        """迭代打印数组"""
        print "[",
        for i,r in enumerate(self.data):
            print r,
            if i < len(self.data)-1:
                print ',',
        print "]"

    def filterAr(self,v):
        """判断输入值是否是指定数组元素的约数，生成是或否的新数组"""
        newar = []
        for a in self.data:
            if a % v == 0:
                newar.append(str(v) + '是')
            else:
                newar.append(str(v) + '不是')
        return newar

    def maximum(self):
        """遍历数组并查找数组中最大值"""
        max = 0
        for a in range(1,len(self.data)):
            if self.data[a] > self.data[max]:
                max = a
        return max

    def swap(self,array,a1,a2):
        """实现数组中两个值的位置互换"""
        temp = array[a1]
        array[a1] = array[a2]
        array[a2] = temp

    def selectSort(self):
        """通过选择排序算法实现顺序排列"""
        for a in range(len(self.data)-1):
            for x in range(a+1,len(self.data)):
                if self.data[a] > self.data[x]:
                    self.swap(self.data,a,x)

    def bubbleSort(self):
        """通过冒泡排序算法实现顺序排列"""
        for a in range(1,len(self.data)):
            for x in range(len(self.data)-a):
                if self.data[x] > self.data[x+1]:
                    self.swap(self.data,x,x+1)

    def bubbleSortPro(self):
        """通过冒泡排序算法实现顺序排列,利用中间变量提高性能"""
        for a in range(len(self.data)-1):
            tmp = self.data[0]
            tp = 0
            for x in range(1,len(self.data)-a):
                if self.data[x] > tmp:
                    tmp = self.data[x]
                    tp = x
            self.swap(self.data,tp,x)

    def search(self,v):
        """在指定数组中循环查找给定值,并返回值所在角标"""
        for i,a in enumerate(self.data):
            if v == a:
                return i
        else:
            return -1

    def binarySearch(self,v):
        """在指定数组中通过折半查找算法查找给定值,并返回值所在角标"""
        bubbleSortPro(self.data)
        low = 0
        high = len(self.data)-1
        while low <= high:
            mid = (low + high)/2
            if self.data[mid] == v:
                return mid
            elif self.data[mid] > v:
               high = mid - 1
            else:
               low = mid + 1
        return -1

def arrayZip(arx,ary):
    """根据两对数组的值,匹配打印判断语句"""
    for x, y in zip(arx, ary):
        print '{0} {1} 的约数'.format(x,y)

if __name__ == '__main__':
    a = array(ar)
    a.rangeArray()
    a.bubbleSort()
    a.rangeArray()
