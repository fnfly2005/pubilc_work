# -*- coding: UTF-8 -*-
#!/usr/local/bin/python

import jieba
import sys
reload(sys)
sys.setdefaultencoding('utf8')

jieba.load_userdict(sys.argv[3])#先加载自定义词典
jieba.enable_parallel(6)#并行分词模式-6核心


with open(sys.argv[1]) as c1, open(sys.argv[2],'w') as c2:
		#cws=c1.readlines()[0]
	for cws in c1:
		c=cws.encode('utf-8').split(',',2)
		result=jieba.cut(c[1])#精准分词
		l=""
		for r in result:
			if r!='\n' and r!=' ':
				l=l+'\t'+r
		c2.write(c[0]+l+'\r'+'\n')
