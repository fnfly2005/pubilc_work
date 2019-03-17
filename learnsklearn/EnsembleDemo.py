#!/usr/bin/python
#coding:utf-8
"""
Description:集成学习之投票器 
"""
from sklearn.ensemble import VotingClassifier
from sklearn.model_selection import train_test_split,GridSearchCV,cross_val_score
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.metrics import make_scorer,f1_score
import numpy as np

scaler = StandardScaler()
pre_scorer = make_scorer(score_func=f1_score,greater_is_better=True,average='micro')

if __name__ == '__main__':
    from sklearn.datasets import load_iris
    from sklearn import svm
    from sklearn.neural_network import MLPClassifier
    from sklearn.ensemble import RandomForestClassifier
    iris = load_iris()
    X = iris.data
    y = iris.target
    X_train, X_test, y_train, y_test = train_test_split(X,y,test_size = 0.2)
    
    param_range = [0.0001, 0.001, 0.01, 0.1, 1.0, 10.0, 100.0, 1000.0]
    svm = svm.SVC()
    nnt = MLPClassifier(solver='lbfgs')
    rfc = RandomForestClassifier(n_estimators=10,n_jobs=-1)

    vcf = VotingClassifier(estimators = [('cls',svm),('cln',nnt),('clr',rfc)])
    pipe_cv = Pipeline([('sca',scaler),('pipe',vcf)])

    pgd = {'pipe__cls__C': param_range,'pipe__cls__kernel':['linear'],\
        'pipe__cln__hidden_layer_sizes':[(2),(4),(6),(2,2),(4,2),(4,4),(6,2),(6,4),(6,6)],\
        'pipe__clr__max_depth':[2,3,4]}

    gsc = GridSearchCV(estimator = pipe_cv,param_grid = pgd,cv=5,n_jobs=-1)
    gsc.fit(X_train,y_train)

    scores = cross_val_score(gsc,X_train,y_train,scoring=pre_scorer,cv=5)

    print ("best_score: ",gsc.best_score_)
    print ("best_params: ",gsc.best_params_)
    print ("CV accuracy: %.3f +/- %.3f" % (np.mean(scores), np.std(scores)))
    print ("test_F1score: ",gsc.score(X_test,y_test))
