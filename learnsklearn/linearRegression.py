#!/usr/bin/python
# coding: utf-8
from sklearn import datasets #数据集模块
from sklearn import preprocessing #特征处理模块
from sklearn import linear_model #广义线性模块
from sklearn import model_selection #模型选择模块

def boston():
    boston = datasets.load_boston()#导入数据集,波士顿房价数据
    train_data = boston.data #获取特征向量
    train_target = boston.target #获得样本标签
    X_train,X_test, y_train, y_test = model_selection.train_test_split(train_data,train_target,test_size=0.2)#切分数据集
    linear=linear_model.LinearRegression(normalize=True)#线性回归模型，设置normalize参数对特征进行缩放
    linear.fit(X_train,y_train)#训练模型参数

    print "linear's score: ",linear.score(X_train,y_train)#评分函数，返回R方，拟合优度
    print "predict: ",linear.predict(X_test)#分类器应用
    print y_test

if __name__ == '__main__':
    boston()
