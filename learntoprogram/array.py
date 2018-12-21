#!/usr/bin/python
#coding:utf-8
##################################
"""
Description:数组
Version: v1.0
"""
##################################
ar = [12,443,32,5,500,27,200,64]

def filterAr(array,v):
    """判断输入值是否是指定数组元素的约数，生成是或否的新数组"""
    newar = []
    for a in array:
        if a % v == 0:
            newar.append(str(v) + '是')
        else:
            newar.append(str(v) + '不是')
    return newar

def arrayZip(arx,ary):
    """根据两对数组的值,匹配打印判断语句"""
    for x, y in zip(arx, ary):
        print '{0} {1} 的约数'.format(x,y)

def maximum(array):
    """遍历数组并查找数组中最大值"""
    max = 0
    for a in range(1,len(array)):
        if array[a] > array[max]:
            max = a
    return max

def swap(array,a1,a2):
    """实现数组中两个值的位置互换"""
    temp = array[a1]
    array[a1] = array[a2]
    array[a2] = temp

def selectSort(arr):
    """通过选择排序算法实现顺序排列"""
    for a in range(len(arr)-1):
        for x in range(a+1,len(arr)):
            if arr[a] > arr[x]:
                swap(arr,a,x)

def bubbleSort(arr):
    """通过冒泡排序算法实现顺序排列"""
    for a in range(1,len(arr)):
        for x in range(len(arr)-a):
            if arr[x] > arr[x+1]:
                swap(arr,x,x+1)

def bubbleSortPro(arr):
    """通过冒泡排序算法实现顺序排列,利用中间变量提高性能"""
    for a in range(len(arr)-1):
        tmp = arr[0]
        tp = 0
        for x in range(1,len(arr)-a):
            if arr[x] > tmp:
                tmp = arr[x]
                tp = x
        swap(arr,tp,x)

def rangeTest(a):
    for r in range(a):
        print r

def search(arr,v):
    """在指定数组中循环查找给定值,并返回值所在角标"""
    for i,a in enumerate(arr):
        if v == a:
            return i
    else:
        return -1

def binarySearch(arr,v):
    """在指定数组中通过折半查找算法查找给定值,并返回值所在角标"""
    bubbleSortPro(arr)
    low = 0
    high = len(arr)-1
    while low <= high:
        mid = (low + high)/2
        if arr[mid] == v:
            return mid
        elif arr[mid] > v:
           high = mid - 1
        else:
           low = mid + 1
    return -1

if __name__ == '__main__':
    arb = filterAr(ar,3)
    arrayZip(arb,ar)
