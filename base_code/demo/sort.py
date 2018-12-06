#!/usr/bin/python
#coding:utf-8
ar=[12,443,32,5,500]

def swap(array,a1,a2):
    """实现数组中两个值的位置互换"""
    temp=array[a1]
    array[a1]=array[a2]
    array[a2]=temp

def selectSort(arr):
    """通过选择排序算法实现顺序排列"""
    for a in range(len(arr)-1):
        for x in range(a+1,len(arr)):
            if arr[a]>arr[x]:
                swap(arr,a,x)

def bubbleSort(arr):
    """通过冒泡排序算法实现顺序排列"""
    for a in range(1,len(arr)):
        for x in range(len(arr)-a):
            if arr[x]>arr[x+1]:
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
        else:
            swap(arr,tp,x)

def rangeTest(a):
    for r in range(a):
        print r

if __name__ == '__main__':
    print ar
    selectSort(ar)
    print ar
