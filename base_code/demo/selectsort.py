#!/usr/bin/python
#coding:utf-8
ar=[12,443,32,5,-5]
def selectsort(arr):
    #通过选择排序算法实现顺序排列
    for a in range(0,len(arr)-1):
        for x in range(a+1,len(arr)):
            if arr[a]>arr[x]:
                temp=arr[a]
                arr[a]=arr[x]
                arr[x]=temp

if __name__ == '__main__':
    print ar
    selectsort(ar)
    print ar
