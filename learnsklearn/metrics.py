#!/usr/bin/python
#coding:utf-8
##################################
"""
Description: 算法评估
二分类评估:精确、召回、F1
Version: v1.0
"""
##################################
from sklearn import metrics

if __name__ == '__main__':
    y_pred=[0,1,0,0,1,1,1,1]
    y_true=[0,1,0,1,1,1,0,0]

    print "Precision:"+str(metrics.precision_score(y_true,y_pred))#精确率
    print "Recall:"+str(metrics.recall_score(y_true,y_pred))#召回率
    print "F1_score:"+str(metrics.f1_score(y_true,y_pred))#F1值
