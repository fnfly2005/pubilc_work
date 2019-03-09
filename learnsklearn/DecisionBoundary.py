#!/usr/bin/python
#coding:utf-8
"""
Description: 决策边界可视化
"""
import numpy as np
from matplotlib.colors import ListedColormap
import matplotlib.pyplot as plt
plt.switch_backend('agg')

class fitScore(object):
    '''模型训练'''
    def __init__(self,X,y,model):
        from sklearn.preprocessing import StandardScaler
        from sklearn.model_selection import train_test_split
        from sklearn.metrics import accuracy_score
        X_train,X_test,y_train,y_test = train_test_split(X,y,test_size=0.3)

        sc = StandardScaler()
        sc.fit(X_train)
        X_train_std = sc.transform(X_train)
        X_test_std = sc.transform(X_test)

        self.X_combined_std = np.vstack((X_train_std,X_test_std))
        self.y_combined = np.hstack((y_train,y_test))
        self.model = model
        self.model.fit(X_train_std,y_train)

        y_pred = self.model.predict(X_test_std)
        print (y_test != y_pred).sum() #返回错误的样本数
        print '%.2f' % accuracy_score(y_test,y_pred) #分类准确率

def plot_decision_regions(X,y,classifier,test_idx=None,resolution=0.02):
    '''绘出决策边界'''
    markers = ('s','x','o','^','v')#设置标记
    colors = ('red','blue','lightgreen','gray','cyan')#设置颜色
    cmap = ListedColormap(colors[:len(np.unique(y))])
    #两个特征的值域范围
    x1_min, x1_max = X[:,0].min() - 1, X[:,0].max() + 1
    x2_min, x2_max = X[:,1].min() - 1, X[:,1].max() + 1
    #从坐标向量中返回坐标矩阵
    xx1, xx2 = np.meshgrid(np.arange(x1_min, x1_max, resolution),np.arange(x2_min, x2_max, resolution))
    Z = classifier.predict(np.array([xx1.ravel(), xx2.ravel()]).T)
    Z = Z.reshape(xx1.shape)
    plt.contourf(xx1, xx2, Z, alpha=0.4, cmap = cmap) #绘制等高线
    #设置横纵坐标轴范围
    plt.xlim(xx1.min(),xx1.max())
    plt.ylim(xx2.min(),xx2.max())
    #画出所有样本点
    X_test, y_test = X[test_idx, :],y[test_idx]
    for idx,cl in enumerate(np.unique(y)):
        plt.scatter(x=X[y == cl, 0], y=X[y == cl,1],alpha=0.8, c=cmap(idx),marker=markers[idx], label=cl)

if __name__ == '__main__':
    from sklearn import datasets
    from sklearn.linear_model import Perceptron
    from sklearn.linear_model import LogisticRegression
    path = '/Users/fannian/Downloads/'
    iris = datasets.load_iris()
    X = iris.data[:,[2,3]]
    y = iris.target
    ppn = Perceptron(max_iter=40, eta0=0.001)
    lr = LogisticRegression(C=1000)
    f = fitScore(X=X,y=y,model=lr)

    plot_decision_regions(X=f.X_combined_std,y=f.y_combined,classifier=f.model,test_idx=range(105,150))
    plt.xlabel('petal length [standardized]')
    plt.ylabel('petal width [standardized]')
    plt.legend(loc='upper left') #显示图例
    plt.savefig(path + 'decision_figure.png')
