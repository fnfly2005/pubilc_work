#!/usr/bin/python
#coding:utf-8
'''
Description: 随机森林、极限随机树、L1特征选择
'''
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier,ExtraTreesClassifier
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.feature_selection import SelectFromModel
from sklearn.pipeline import Pipeline
from sklearn.svm import LinearSVC

iris = load_iris()
X = iris.data
y = iris.target
X_train, X_test, y_train, y_test = train_test_split(X,y,test_size = 0.2)

forest = RandomForestClassifier(n_estimators=10)
extree = ExtraTreesClassifier(n_estimators=10)
fea_sel = SelectFromModel(LinearSVC(penalty="l1",dual=False))
ple = Pipeline([('sca',StandardScaler()),('fea_sel',fea_sel),
    ('extree',extree)])

def eneClf(clf,remark):
    clf.fit(X_train,y_train)
    print ("train accuracy: ",remark,clf.score(X_train,y_train))
    print ("test accuracy: ",remark,clf.score(X_test,y_test))
    
if __name__ == '__main__':
    eneClf(forest,"on forest")
    eneClf(extree,"on extree")
    eneClf(ple,"on l1_extree")
