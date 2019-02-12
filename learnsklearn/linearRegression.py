#!/usr/bin/python
# coding: utf-8
"""
Description: 回归算法
回归：最小二乘法、岭回归、套索回归、弹性网络、多项式
"""
from sklearn import datasets
from sklearn.preprocessing import PolynomialFeatures
from sklearn import linear_model as lm
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler

def linearMethod(train_data,train_target,model):
    X_train, X_test, y_train, y_test = train_test_split(train_data,train_target,test_size=0.2)#切分数据集

    #对特征数据进行归一化处理
    scaler = StandardScaler()
    scaler.fit(X_train)
    X_train = scaler.transform(X_train)
    X_test = scaler.transform(X_test)

    if model == 'Ridge':
        linear = lm.RidgeCV()#岭回归交叉验证，对惩罚系数进行调优
    elif model == 'Lasso':
        linear = lm.LassoCV()#套索回归交叉验证，对惩罚系数进行调优
        #linear = lm.Lasso(alpha = reg.alpha_,normalize=True)#套索回归，设置normalize参数对特征进行缩放，设置alpha惩罚系数
    elif model == 'ElasticNet':
        linear = lm.ElasticNetCV()#弹性网络回归交叉验证，对惩罚系数进行调优
        #linear = lm.ElasticNet(alpha = reg.alpha_,normalize=True)#弹性网络回归，设置normalize参数对特征进行缩放，设置alpha惩罚系数
    else:
        linear = lm.LinearRegression()#最小二乘法，设置normalize参数对特征进行缩放

    linear.fit(X_train,y_train)#训练模型参数
    #评分函数，返回R方，拟合优度
    print "train's score: ",linear.score(X_train,y_train)
    print "test's score: ",linear.score(X_test,y_test)

#特征多项式化处理
def polynomialMethod(trans_data,deg):
    poly = PolynomialFeatures(degree = deg)#最高次方
    return poly.fit_transform(trans_data)#转化特征

if __name__ == '__main__':
    boston = datasets.load_boston()#导入数据集,波士顿房价数据
    linearMethod(polynomialMethod(boston.data,3),boston.target,'Ridge')#获取特征向量,获得样本标签,应用至模型
