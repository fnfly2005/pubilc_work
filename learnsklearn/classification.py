#!/usr/bin/python
#coding:utf-8
##################################
"""
Description: 分类算法、降维
逻辑回归、神经网络、SVM
降维：PCA 
Version: v1.0
"""
##################################
from sklearn import datasets,metrics,svm
from sklearn.linear_model import LogisticRegressionCV
from sklearn.neural_network import MLPClassifier
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.decomposition import PCA

def classificationMethod(train_data,train_target,model):
    #切分数据集
    X_train, X_test, y_train, y_test = train_test_split(train_data,train_target,test_size=0.2)

    #对特征数据进行归一化处理
    scaler = StandardScaler()
    scaler.fit(X_train)
    X_train = scaler.transform(X_train)
    X_test = scaler.transform(X_test)

    #PCA压缩数据
    pca = PCA(n_components=0.99) #保留99%的信息
    pca.fit(X_train)
    X_train = pca.transform(X_train)
    X_test = pca.transform(X_test)

    #模型选择
    if model == 'logistic':
        linear = LogisticRegressionCV(cv=5,random_state=0)
    elif model == 'svm':
        linear = svm.SVC(C=1.0,kernel='rbf',gamma=0.1)
    elif model == 'neural_network':
        linear = MLPClassifier(hidden_layer_sizes=(4,2),solver='lbfgs',activation='logistic')
    linear.fit(X_train,y_train)

    #评分
    print "train's score: ",linear.score(X_train,y_train)
    print "test's score: ",linear.score(X_test,y_test)

if __name__ == '__main__':
    iris = datasets.load_iris()
    classificationMethod(iris.data,iris.target,'neural_network')
