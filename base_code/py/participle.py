#!/usr/bin/python
# -*- coding: UTF-8 -*-
import jieba
import sys
import os

reload(sys)
sys.setdefaultencoding('utf8') #设置python默认编码为utf8

home=os.environ.get('home')

pat=home + '/data/'


with open(pat+sys.argv[1]) as c1, open(pat+sys.argv[2],'w') as c2:
#参数1为输入文件c1，参数2为输出文件c2
    for cws in c1:
        c=cws.encode('utf-8').split(',',2)#切分2次
        result=jieba.cut(c[1])#取第二个切片，精准分词
        l=0
        for r in result:
            if r!='\n' and r!=' ':
                c2.write(c[0]+","+r+","+str(l)+'\n')
                l+=1
