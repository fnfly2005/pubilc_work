#!/usr/bin/python
#coding:utf-8
"""
Description: 聚类算法
k-means
"""
from sklearn.datasets import make_blobs
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score
import matplotlib.pyplot as plt
import numpy as np
plt.switch_backend('agg')

#path = '/Users/fannian/Documents/'
path = '/home/fannian/downloads/'
if __name__ == '__main__':
    #n_samples-样本数 n_features-特征数 centers-簇数 X-特征数组 y-簇标签
    X,y = make_blobs(n_samples=1000,n_features=4,centers=2)
    X_train, X_test, y_train, y_test = train_test_split(X,y,test_size=0.2)

    #对特征数据进行归一化处理
    scaler = StandardScaler()
    scaler.fit(X_train)
    X_train = scaler.transform(X_train)
    X_test = scaler.transform(X_test)
    
    #最佳簇数选择
    K = range(2,10)
    ceof = []
    for k in K:
        reg = KMeans(n_clusters=k,n_init=100)
        reg.fit(X_train)
        score = silhouette_score(X_train,reg.labels_)#轮廓系数-对应于畸变函数
        ceof.append(score)

    fig = plt.figure()
    fig,ax_lst = plt.subplots(1,1)
    ax_lst.set_xticklabels(np.arange(1,10,1))#设置子图X轴的精度和范围
    
    ax_lst.plot(K,ceof)
    fig.savefig(path + 'figure.png')

