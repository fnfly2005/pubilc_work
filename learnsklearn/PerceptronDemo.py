#!/usr/bin/python
#coding:utf-8
"""
Description: 感知器算法-分类
"""
import numpy as np
import pandas as pd
from sklearn.datasets import load_iris

class Perceptron(object):
    """感知器分类
    
    Parameters
    ----------
    eta: float
        学习速率 (取值在 0.0 到 1.0 之间)
    n_iter: int
        模型算法迭代次数

    Attributes
    ----------
    w_: 1d-array
        权重向量
    errors_: list
        每次学习错误分类的数量
    """

    def __init__(self,eta = 0.01,n_iter=10):
        self.eta = eta
        self.n_iter = n_iter

    def fit(self, X, y):
        """训练函数

        Parameters
        ----------
        X: {array-like}, shape = [n_samples, n_features]
            特征向量
        y: array-like,shape = [n_samples]
            类标

        Returns
        ----------
        self: object
        """

        self.w_ = np.zeros(1 + X.shape[1]) # 权值初始化为一个零向量R^(m+1), 数据特征的数量: m = X.shape[1] ,并增加一个0权重列-阈值
        self.errors_ = []

        for _ in range(self.n_iter):
            errors = 0
            """类似随机梯度的代价函数"""
            for xi, target in zip(X,y):
                update = self.eta * (target - self.predict(xi))
                self.w_[1:] += update * xi #x_i的权重array
                self.w_[0] += update #θ_0 值
                errors += int(update != 0.0) #J(θ)值
            self.errors_.append(errors)
        return self

    def net_input(self, X):
        """计算预测函数"""
        return np.dot(X,self.w_[1:]) + self.w_[0]

    def predict(self, X):
        """返回数据类标"""
        return np.where(self.net_input(X) >= 0.0, 1, -1)

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
    print X.shape[1]
