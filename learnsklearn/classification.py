#!/usr/bin/python
#coding:utf-8
##################################
"""
Description: 分类算法
逻辑回归
Version: v1.0
"""
##################################
from sklearn import datasets
from sklearn.linear_model import LogisticRegressionCV
from sklearn.model_selection import train_test_split
from sklearn import metrics

#逻辑回归
def logisticMethod(train_data,train_target):
    #切分数据集
    X_train, X_test, y_train, y_test = train_test_split(train_data,train_target,test_size=0.2)

    #使用交叉验证进行训练
    linear = LogisticRegressionCV(cv=5,random_state=0)
    linear.fit(X_train,y_train)

    #评分
    print "train's score: ",linear.score(X_train,y_train)
    print "test's score: ",linear.score(X_test,y_test)

if __name__ == '__main__':
    iris = datasets.load_iris()
    logisticMethod(iris.data,iris.target)
