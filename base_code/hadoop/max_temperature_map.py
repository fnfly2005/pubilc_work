#!/Users/fannian/anaconda3/bin/python
#coding:utf-8
"""
Description: map函数
"""
import re
import sys

for line in sys.stdin:
    val = line.strip()
    (year,temp,q)=(val[15:19],val[87:92],val[92:93])
    if(temp!="+9999" and re.match("[01459]",q)):
        print("%s\t%s" % (year,temp))
