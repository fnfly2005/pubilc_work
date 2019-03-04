#!/usr/bin/python
#coding:utf-8
"""
Description: txt csv 格式转换
"""
import sys
import pandas as pd
import numpy as np

if __name__ == '__main__':
    in_file = sys.argv[1] #输入txt
    out_file = sys.argv[2] #输出csv
    data_txt = np.loadtxt(in_file)
    data_txtDF = pd.DataFrame(data_txt)
    data_txtDF.to_csv(out_file,index=False)
