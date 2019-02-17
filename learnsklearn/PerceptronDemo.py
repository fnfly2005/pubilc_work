#!/usr/bin/python
#coding:utf-8
"""
Description: 感知器算法
"""
import numpy as np
import pandas as pd
from sklearn.datasets import load_iris

#转化datasets为dataframe
def npToPd(npdata):
    #np.c_是按行连接两个矩阵，就是把两矩阵左右相加，要求行数相等，类似于pandas中的merge()
    data = np.c_[npdata['data'], npdata['target']] 

    columns = npdata['feature_names'] + ['target']#获取特征名称的数组
    return pd.DataFrame(data = data,columns = columns) #通过np矩阵生成dataframe
    
if __name__ == '__main__':
    #生成鸢尾花数据-二分类
    df = npToPd(load_iris()) #生成dataframe
    y = df.iloc[0:100,4].values #取前100行类表数据
    y = np.where(y == 0, -1 , 1) #将0类标改为-1
    X = df.iloc[0:100,[0,2]].values #取前100行特征数据
