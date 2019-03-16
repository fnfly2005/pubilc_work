#!/usr/bin/python
#coding:utf-8
"""
Description: 分类算法、降维、求解器、管道流水线、网格搜索
逻辑回归、神经网络、SVM、感知器
降维：PCA 
求解器：随机梯度下降、平均梯度下降
"""
import numpy as np

class ClassifyPipeline(object):
    def __init__(self,train_data,train_target,linear,param_grid,n_com=0.99):
        from sklearn.pipeline import Pipeline
        from sklearn.preprocessing import StandardScaler
        from sklearn.model_selection import train_test_split
        from sklearn.decomposition import PCA
        from sklearn.model_selection import GridSearchCV
        from sklearn.model_selection import cross_val_score
        self.X_train, self.X_test, self.y_train, self.y_test = train_test_split(train_data,train_target,test_size=0.2)#切分数据集
        scaler = StandardScaler()#对特征数据进行归一化处理
        pcaer = PCA(n_components = n_com) #PCA压缩数据-保留n_com%的信息或n_com个维度
        pipe_cv = Pipeline([('scl',scaler),('pca',pcaer),('clf',linear)])#流水线整合各个模型,可通过标识符访问其中各个元素
        self.linear = GridSearchCV(estimator = pipe_cv,param_grid = param_grid,\
            scoring = 'accuracy',cv = 5,n_jobs=-1)#网格搜索实现半自动调参
        self.linear.fit(self.X_train,self.y_train)#训练模型
        self.scores = cross_val_score(self.linear,train_data,train_target,\
            scoring='accuracy',cv=5)#嵌套交叉验证比较不同模型之间的性能

    def getScore(self):
        print "best_score: ",self.linear.best_score_
        print "best_params: ",self.linear.best_params_
        print "CV accuracy: %.3f +/- %.3f" % (np.mean(self.scores), np.std(self.scores))

if __name__ == '__main__':
    from sklearn.linear_model import LogisticRegression
    from sklearn.linear_model import SGDClassifier
    from sklearn.linear_model import Perceptron
    from sklearn.neural_network import MLPClassifier
    from sklearn import datasets,svm
    iris = datasets.load_iris()
    param_range = [0.00001, 0.0001, 0.001, 0.01, 0.1, 1.0, 10.0, 100.0, 1000.0]
    param_ratio = [0, 0.15, 0.3, 0.45, 0.6, 0.75, 0.9, 1]

    param_ppn = [{'clf__alpha':param_range}]
    ppn = Perceptron(max_iter=40, eta0=0.001)#感知器-数据必须严格的线性可分，不然无法收敛

    param_log = [{'clf__C':param_range}]
    log = LogisticRegression()#逻辑回归-输出概率值，对离群点数据有较好效果

    param_Lsvm = [{'clf__C':param_range,'clf__loss':['hinge','squared_hinge']}]
    Lsvm = svm.LinearSVC()#svm-线性SVM专用方法，对临界点有较好的区分;该函数额外支持损失函数和L1惩罚

    param_Ssvm = [{'clf__C':param_range,'clf__kernel':['linear']},\
        {'clf__C':param_range,'clf__gamma':param_range,'clf__kernel':['rbf']}]
    Ssvm = svm.SVC()#通用svm-支持线性SVM和高斯核SVM

    param_nnt = [{'clf__hidden_layer_sizes':[(2),(4),(6),(8),(2,2),(4,2),(4,4),(6,2),(6,4),(8,2),(8,4)],\
        'clf__activation':['logistic','relu','tanh']}]
    nnt = MLPClassifier(solver='lbfgs') #bp神经网络-适用于复杂逻辑判断

    param_SGD = [{'clf__loss':['log','hinge'], 'clf__average':[False,5,10], \
        'clf__l1_ratio':param_ratio}]
    SGD = SGDClassifier(max_iter=1000) #随机梯度下降-求解器，适合大规模数据集,partial_fit支持在线学习

    cm = ClassifyPipeline(iris.data,iris.target,linear=SGD,param_grid = param_SGD)
    cm.getScore()
