#!/usr/bin/python
#coding:utf-8
"""
Description: 非线性分类器
#svm-基于高斯核函数的SVM，对线性不可分的数据集有效
#KNN-基于数据集最近距离的X个样本，惰性学习-K近邻
"""
from sklearn import svm
import DecisionBoundary as db
import matplotlib.pyplot as plt
from sklearn.neighbors import KNeighborsClassifier

class XorSample(object):
    def __init__(self,num,classifier):
        import numpy as np
        np.random.seed(0)
        self.X = np.random.randn(num,2) #返回一组正态分布的样本 m*n
        y_xor = np.logical_xor(self.X[:,0] > 0, self.X[:,1] > 0) #计算X_xor两个特征的异或矩阵
        self.y = np.where(y_xor,1,-1)
        self.classifier = classifier
        self.classifier.fit(self.X,self.y)


if __name__ == '__main__':
    #path = '/Users/fannian/Downloads/'
    path = '/home/fannian/downloads/'
    
    '''参数C越大，惩罚影响越小，模型倾向于过拟合
    参数gamma越大，模型倾向于过拟合'''
    Rsvm = svm.SVC(C = 10,kernel = 'rbf',gamma = 1)

    '''n_neighbors近邻个数,metric距离度量'''
    knn = KNeighborsClassifier(n_neighbors=5, p=2, metric='minkowski')
    
    s = XorSample(200,classifier = knn)
    db.plot_decision_regions(s.X,s.y,classifier = s.classifier,path_file = path + 'decision_figure.png')
