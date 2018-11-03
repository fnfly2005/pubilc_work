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
from re import match

dic=['退款/退换货','交易成功','花呗账单','运费险已失效','买家已付款','仓库已发货','保险服务','订单详情','查看物流','确认收货','再次购买','申请开票','发货清单','申请售后','追加评论','双方已评','我已评价']

def workflow():
    sku_data = []
    order_data = []
    all_data = []
    i = 0
    n = 1
    for stline in sys.stdin:
        line = stline.strip()
        if len(line) > 0 and line not in dic \
            and match('[\S]+含运费[\S]+|[\S]+\：[\S]+|还剩[\S]+',line) == None:
            #剔除无效数据行
            if i == 0:
                order_data.append(line)
                i = 1
            elif match('[\S]+订单号[\S]+',line) == None:
                if i == 4:
                    order_data.append(line)
                elif n == 3:
                    sku_data.append(line)
                    order_data.append(sku_data)
                    sku_data = []
                    n = 1
                elif n == 1 and match('￥[\S]+',line) != None:
                    n = 1
                else:
                    sku_data.append(line)
                    n = n+1
                i = i+1
            else:
                all_data.append(order_data)
                order_data = []
                order_data.append(line)
                i = 1
    for oid in all_data:
        totalprice=str(oid.pop(2))[3:]
        orderdt=str(oid.pop(0))[0:10]
        for i in oid:
            print orderdt + ',' + totalprice + ',' + \
            str(i[0]).strip() + ',' + str(i[1][3:]) + ',' + str(i[2])

if __name__ == '__main__':
    workflow()
