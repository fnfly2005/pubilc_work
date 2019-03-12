#!/usr/bin/python
#coding:utf-8
"""
Description: 特征重要性判断-随机森林
"""

if __name__ == '__main__':
    import numpy as np
    import matplotlib.pyplot as plt
    from sklearn import datasets
    path = '/Users/fannian/Documents/'
    iris = datasets.load_iris()
    feat_labels = iris.feature_names
    from sklearn.ensemble import RandomForestClassifier
    forest = RandomForestClassifier(n_estimators=1000,n_jobs=2)
    X = iris.data
    y = iris.target
    forest.fit(X,y)
    importances = forest.feature_importances_
    indices = np.argsort(importances)[::-1]
    for f in range(X.shape[1]):
        print feat_labels[f] + " " + str(importances[indices[f]])

    plt.title('Feature Importances')
    plt.bar(range(X.shape[1]),importances[indices],color='lightblue',align='center') #绘制柱状图
    plt.xticks(range(X.shape[1]),feat_labels,rotation=90) #设置X轴刻度值
    plt.xlim([-1,X.shape[1]])
    plt.tight_layout()
    plt.savefig(path + 'figure.png')
