#!/usr/bin/python
#coding:utf-8
"""
Description: 决策树及其可视化
"""
from sklearn.tree import DecisionTreeClassifier
import DecisionBoundary as db
from sklearn import datasets
from sklearn.tree import export_graphviz

if __name__ == '__main__':
    #path = '/Users/fannian/Downloads/'
    path = '/home/fannian/downloads/'
    iris = datasets.load_iris()
    X = iris.data[:,[2,3]]
    y = iris.target

    param_grid = [{'clf__max_depth':[2,3,4]}]
    tree = DecisionTreeClassifier()

    f = db.fitScore(X=X,y=y,model=tree,param_grid=param_grid)
    f.getScore()
    db.plot_decision_regions(X=f.X_combined_std,y=f.y_combined,classifier=f.linear,\
        test_idx=range(105,150),path_file = path + 'decision_figure.png')

    #export_graphviz 会检测模型是否为决策树，如果为其他模型，则会报错，固使用网格搜索需要重新训练
    tre = DecisionTreeClassifier(max_depth=f.linear.best_params_['clf__max_depth'])
    tre.fit(X,y)
    export_graphviz(tre,out_file=path +'tree.dot',\
        feature_names=['petal length','petal width'])
