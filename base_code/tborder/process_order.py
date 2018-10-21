#!/usr/bin/python
#coding:utf-8
##################################
'''
Path: 
Description: 淘宝订单清洗
Version: v1.0
'''
##################################
import sys
import re

dic1=['退款/退换货','交易成功','花呗账单','运费险已失效','买家已付款','仓库已发货','保险服务','订单详情','查看物流','确认收货','再次购买','申请开票','发货清单','申请售后','追加评论','双方已评']

def workflow():
    for line in sys.stdin:
        line_srp = line.strip()
        if len(line_srp) > 0 and line_srp not in dic1 \
            and re.match('\(含运费[\S]+|[\S]+\：[\S]+|还剩[\S]+',line_srp) == None:
            print line_srp

if __name__ == '__main__':
    workflow()
