#!/usr/bin/python
#coding:utf-8
"""
Description: 非线性分类器
#svm-基于高斯核函数的SVM，对线性不可分的数据集有效
"""
from sklearn import svm
import DecisionBoundary as db
import matplotlib.pyplot as plt

class XorSample(object):
    def __init__(self,num):
        import numpy as np
        np.random.seed(0)
        self.X = np.random.randn(num,2) #返回一组正态分布的样本 m*n
        y_xor = np.logical_xor(self.X[:,0] > 0, self.X[:,1] > 0) #计算X_xor两个特征的异或矩阵
        self.y = np.where(y_xor,1,-1)

if __name__ == '__main__':
    #path = '/Users/fannian/Downloads/'
    path = '/home/fannian/downloads/'
    s = XorSample(200)
    
    '''参数C越大，惩罚影响越小，模型倾向于过拟合
    参数gamma越大，模型倾向于过拟合'''
    svm = svm.SVC(C=10,kernel='rbf',gamma=1)
    svm.fit(s.X,s.y)
    
    db.plot_decision_regions(s.X,s.y,classifier=svm,path_file = path + 'decision_figure.png')
