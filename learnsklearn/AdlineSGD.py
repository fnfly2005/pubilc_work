#!/usr/bin/python
#coding:utf-8
"""
Description: 自适应线性神经元算法-随机梯度求解
"""
import numpy as np
import pandas as pd
from numpy.random import seed
import matplotlib.pyplot as plt
from sklearn.datasets import load_iris
plt.switch_backend('agg')

class AdlineSGD(object):
    """
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
    error_: list
        每次学习错误分类的数量
    shuffle: bool (default: True)
        每次循环进行随机排序
    random_state: in (default: None)
        随机数种子和初始权重
    """

    def __init__(self,eta = 0.01,n_iter = 10,shuffle = True, random_state = None):
        self.eta = eta
        self.n_iter = n_iter
        self.w_initialized = False
        self.shuffle = shuffle
        if random_state:
            seed(random_state)

    def _initialize_weights(self,m):
        """权值初始化为一个零向量R^(m+1), 数据特征的数量: m = X.shape[1] ,并增加一个0权重列-阈值"""
        self.w_ = np.zeros(1 + m) 
        self.w_initialized = True

    def _shuffle(self,X,y):
        """打乱训练数据"""
        r = np.random.permutation(len(y))#返回一个洗牌后的等差数列-矩阵形式
        return X[r], y[r] #返回洗牌后的矩阵

    def _update_weights(self,xi,target):
        """更新权重"""
        output = self.net_input(xi)
        error = (target - output) 

        #样本权重增量=其对应n_samples*误差*学习系数
        self.w_[1:] += self.eta * xi.dot(error) 
        self.w_[0] += self.eta * error
        #计算每个样本的代价函数
        cost = 0.5 * error**2
        return cost

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

        self._initialize_weights(X.shape[1])
        self.cost_ = [] #代价函数数组

        for i in range(self.n_iter):
            if self.shuffle:
                X, y = self._shuffle(X, y) #返回洗牌后的矩阵

            #存储代价函数
            cost = []
            for xi, target in zip(X,y):
                cost.append(self._update_weights(xi,target))
            avg_cost = sum(cost)/len(y)
            self.cost_.append(avg_cost)
        return self

    def partial_fit(self,X,y):
        """无初始化权重训练函数"""
        pass
            
    def net_input(self, X):
        """计算输入函数"""
        return np.dot(X,self.w_[1:]) + self.w_[0]

    def activation(self,X):
        """计算激活函数"""
        return self.net_input(X)

    def predict(self, X):
        """返回数据类标"""
        return np.where(self.activation(X) >= 0.0, 1, -1)

#转化datasets为dataframe
def npToPd(npdata):
    #np.c_是按行连接两个矩阵，就是把两矩阵左右相加，要求行数相等，类似于pandas中的merge()
    data = np.c_[npdata['data'], npdata['target']] 

    columns = npdata['feature_names'] + ['target']#获取特征名称的数组
    return pd.DataFrame(data = data,columns = columns) #通过np矩阵生成dataframe
    
if __name__ == '__main__':
    #path ='/home/fannian/downloads/'
    path ='/Users/fannian/Downloads/'
    
    #生成鸢尾花数据-二分类
    df = npToPd(load_iris()) #生成dataframe
    y = df.iloc[0:100,4].values #取前100行类标数据
    y = np.where(y == 0, -1 , 1) #将0类标改为-1
    X = df.iloc[0:100,[0,2]].values #取前100行特征数据

    #输出迭代次数与错误分析
    ppn = AdlineSGD(eta = 0.0001, n_iter =10) #调小学习速率，直到代价函数收敛
    ppn.fit(X,y)
    plt.plot(range(1,len(ppn.cost_) + 1), ppn.cost_,marker='o') #marker='o' 小圆点
    plt.xlabel('Epochs')
    plt.ylabel('Number of misclassifications')
    plt.savefig(path + 'figure.png')
