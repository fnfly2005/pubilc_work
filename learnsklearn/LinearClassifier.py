#!/usr/bin/python
#coding:utf-8
"""
Description: 分类算法、降维、求解器
逻辑回归、神经网络、SVM、感知器
降维：PCA 
求解器：随机梯度下降、平均梯度下降
"""
from sklearn import datasets,metrics,svm
from sklearn.linear_model import LogisticRegressionCV
from sklearn.linear_model import SGDClassifier
from sklearn.linear_model import Perceptron
from sklearn.neural_network import MLPClassifier
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.decomposition import PCA

def classificationMethod(train_data,train_target,linear):
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

    #训练评分
    linear.fit(X_train,y_train)
    print "train's score: ",linear.score(X_train,y_train)
    print "test's score: ",linear.score(X_test,y_test)

if __name__ == '__main__':
    iris = datasets.load_iris()

    ppn = Perceptron(max_iter=40, eta0=0.001)#感知器-数据必须严格的线性可分，不然无法收敛
    log = LogisticRegressionCV(cv=5,random_state=0)#逻辑回归-输出概率值，对离群点数据有较好效果
    svm = svm.LinearSVC()#svm-线性SVM，输出类标，对临界点有较好的区分;该函数支持正则化和损失函数
    lsvm = svm.SVC(C=1.0,kernel='linear')#svm-线性SVM，采用默认设置
    neural_network = MLPClassifier(hidden_layer_sizes=(4,2),solver='lbfgs',activation='logistic') #bp神经网络-适用于复杂逻辑判断
    SGDlog = SGDClassifier(loss='log',penalty='l2',max_iter=1000) #随机梯度下降-求解器，适合大规模数据集,partial_fit支持在线学习
    SAGlsvm = SGDClassifier(loss='hinge',l1_ratio=0.15,average=5,max_iter=1000) #平均梯度下降-求解器，适合中大规模数据集

    classificationMethod(iris.data,iris.target,linear=lsvm)
