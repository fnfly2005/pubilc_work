#!/usr/bin/python
#coding:utf-8
"""
Description: 感知器算法-分类类库调用版
"""
from sklearn import datasets
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.linear_model import Perceptron
from sklearn.metrics import accuracy_score
import numpy as np

iris = datasets.load_iris()
X = iris.data[:,[2,3]]
y = iris.target

X_train,X_test,y_train,y_test = train_test_split(X,y,test_size=0.3)

sc = StandardScaler()
sc.fit(X_train)
X_train_std = sc.transform(X_train)
X_test_std = sc.transform(X_test)

ppn = Perceptron(max_iter=40, eta0=0.001)
ppn.fit(X_train_std,y_train)
y_pred = ppn.predict(X_test_std)

if __name__ == '__main__':
    print np.unique(y) #返回去重后的y矩阵
    print (y_test != y_pred).sum() #返回错误的样本数
    print '%.2f' % accuracy_score(y_test,y_pred) #分类准确率
