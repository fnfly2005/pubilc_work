#!/usr/bin/python
#coding:utf-8
##################################
"""
Description: 神经网络模型
Version: v1.0
"""
##################################
from sklearn import datasets
from sklearn.neural_network import MLPClassifier
from sklearn import preprocessing
from sklearn import model_selection

if __name__ == '__main__':
    iris = datasets.load_iris()

    X_train, X_test, y_train, y_test = model_selection.train_test_split(iris.data,iris.target,test_size=0.2)

    #对特征数据进行归一化处理
    scaler = preprocessing.StandardScaler()
    scaler.fit(X_train)
    X_train = scaler.transform(X_train)
    X_test = scaler.transform(X_test)

    #训练&评价
    mlp = MLPClassifier(hidden_layer_sizes=(4,2),solver='lbfgs',activation='logistic')
    mlp.fit(X_train,y_train)
    print mlp.score(X_train,y_train),
    print mlp.score(X_test,y_test)

    #预测
    print mlp.predict(X_test)
    print y_test
