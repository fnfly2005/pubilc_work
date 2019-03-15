#!/usr/bin/python
#coding:utf-8
"""
Description: 分类算法、降维、求解器、管道流水线、网格搜索
逻辑回归、神经网络、SVM、感知器
降维：PCA 
求解器：随机梯度下降、平均梯度下降
"""

class ClassifyPipeline(object):
    def __init__(self,train_data,train_target,linear,param_grid,n_com=0.99):
        from sklearn.pipeline import Pipeline
        from sklearn.preprocessing import StandardScaler
        from sklearn.model_selection import train_test_split
        from sklearn.decomposition import PCA
        from sklearn.model_selection import GridSearchCV
        self.X_train, self.X_test, self.y_train, self.y_test = train_test_split(train_data,train_target,test_size=0.2)#切分数据集
        scaler = StandardScaler()#对特征数据进行归一化处理
        pcaer = PCA(n_components = n_com) #PCA压缩数据-保留n_com%的信息或n_com个维度
        pipe_cv = Pipeline([('scl',scaler),('pca',pcaer),('clf',linear)])#流水线整合各个模型,可通过标识符访问其中各个元素
        self.linear = GridSearchCV(estimator = pipe_cv,param_grid = param_grid,\
            scoring = 'accuracy',cv = 10,n_jobs=-1)#网格搜索实现半自动调参
        self.linear.fit(self.X_train,self.y_train)#训练模型

    def getScore(self):
        print "train's score: ",self.linear.score(self.X_train,self.y_train)
        print "test's score: ",self.linear.score(self.X_test,self.y_test)

if __name__ == '__main__':
    from sklearn.linear_model import LogisticRegressionCV
    from sklearn.linear_model import SGDClassifier
    from sklearn.linear_model import Perceptron
    from sklearn.neural_network import MLPClassifier
    from sklearn import datasets,svm
    iris = datasets.load_iris()

    ppn = Perceptron(max_iter=40, eta0=0.001)#感知器-数据必须严格的线性可分，不然无法收敛
    log = LogisticRegressionCV(cv=5,random_state=0)#逻辑回归-输出概率值，对离群点数据有较好效果
    Lsvm = svm.LinearSVC()#svm-线性SVM，输出类标，对临界点有较好的区分;该函数支持正则化和损失函数
    Ssvm = svm.SVC()#svm-线性SVM，采用默认设置
    neural_network = MLPClassifier(hidden_layer_sizes=(4,2),solver='lbfgs',activation='logistic') #bp神经网络-适用于复杂逻辑判断
    SGDlog = SGDClassifier(loss='log',penalty='l2',max_iter=1000) #随机梯度下降-求解器，适合大规模数据集,partial_fit支持在线学习
    SAGlsvm = SGDClassifier(loss='hinge',l1_ratio=0.15,average=5,max_iter=1000) #平均梯度下降-求解器，适合中大规模数据集

    param_range = [0.0001, 0.001, 0.01, 0.1, 1.0, 10.0, 100.0, 1000.0]
    param_grid = [{'clf__C':param_range,'clf__kernel':['linear']}]
    cm = ClassifyPipeline(iris.data,iris.target,linear=Ssvm,param_grid = param_grid)
    cm.getScore()
