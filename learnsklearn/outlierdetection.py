#!/usr/bin/python
#coding:utf-8
"""
Description: 异常值检测
高斯分布算法
"""
import numpy as np
from sklearn.covariance import EllipticEnvelope

n_samples = 125
n_outliers = 25
n_features = 2

# 正常数据 
gen_cov = np.eye(n_features) # 生成2*2单位矩阵
gen_cov[0, 0] = 2 #第0行第0列值设为2
X = np.dot(np.random.randn(n_samples, n_features), gen_cov) #dot点积，np.random.randn生成125*2的0-1的随机数
# 异常值
outliers_cov = np.eye(n_features)
outliers_cov[np.arange(1, n_features), np.arange(1, n_features)] = 7 #第2行第2列设为7
X[-n_outliers:] = np.dot(np.random.randn(n_outliers, n_features), outliers_cov)#将训练集其中25个点变为异常值

ee = EllipticEnvelope(contamination=0.2) #给定异常值的比例
ee.fit(X)

y = ee.predict(X[-5:])

if __name__ == '__main__':
    print X[-5:]
    print y
