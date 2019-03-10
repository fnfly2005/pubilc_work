#!/usr/bin/python
#coding:utf-8
"""
Description: 决策树
"""
from sklearn.tree import DecisionTreeClassifier
from sklearn.tree import export_graphviz
import DecisionBoundary as db

if __name__ == '__main__':
    from sklearn import datasets
    #path = '/Users/fannian/Downloads/'
    path = '/home/fannian/downloads/'
    iris = datasets.load_iris()
    tree = DecisionTreeClassifier(criterion='entropy',max_depth=3)
    f = db.fitScore(X=iris.data[:,[2,3]],y=iris.target,model=tree)
    f.getScore()
    db.plot_decision_regions(X=f.X_combined_std,y=f.y_combined,classifier=f.linear,test_idx=range(105,150),path_file = path + 'decision_figure.png')
    export_graphviz(tree,out_file=path +'tree.dot',feature_names=['petal length','petal width'])
