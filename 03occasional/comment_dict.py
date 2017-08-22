# -*- coding: utf-8 -*-
#!/usr/local/bin/python

import jieba
import jieba.posseg as pseg
import jieba.analyse as ayse
import sys
from collections import defaultdict

reload(sys)
sys.setdefaultencoding('utf8')

ph=r'/data/fannian/'
c1t=ph+'00output/comment_tp1.csv'
c2t=ph+'00output/comment_tp2.csv'
dwt=ph+'02data/dict.txt'

def open_dict(Dict,path=ph+r'02data/'):
	path=path+'%s.txt' %Dict
	with open(path,'r') as dic:
		dict=[]
		for word in dic:
			w=word.strip()
			if len(w)>0:
				dict.append(w)
	return dict

def to_dict(list):
	List=open_dict(list)
	Dict=defaultdict()
	for l in List:
		Dict[l.split(' ')[0]]=l.split(' ')[1]
	return Dict

jieba.load_userdict(dwt)
swl=open_dict('stop_words')
notList=open_dict('not_words')
senDict=to_dict('BosonNLP_sentiment_score')
degreeDict=to_dict('degree_words')

senWord=defaultdict()
notWord=defaultdict()
degreeWord=defaultdict()

with open(c1t) as c1, open(c2t,'w') as c2:
	for cws in c1:
		cl=cws.encode('utf-8').split(',',2)
		result=jieba.cut(cl[1],False)#提取关键词
		l=0
		for r in result:
			if r not in swl and r!='\n' and r!=' ':
				if r in senDict.keys() and r not in notList and r not in degreeDict.keys():
					senWord[l]=senDict[r.encode('utf-8')]
				elif r in notList and r not in degreeDict.keys():
					notWord[l]=-1
				elif r in degreeDict.keys():
					degreeWord[l]=degreeDict[r.encode('utf-8')]
				l+=1
		score=0
		senLoc=senWord.keys()
		notLoc=notWord.keys()
		degreeLoc=degreeWord.keys()
		senloc=0
		W=1
		for j in range(0,senLoc[senloc]):
			if j in notLoc:
				W*=-1
			elif j in degreeLoc:
				W*=float(degreeWord[j])
		for i in range(0,l-1):
			if i in senLoc:
				score+=W*float(senWord[i])
				W=1
				if senloc<len(senLoc)-1:
					for j in range(senLoc[senloc],senLoc[senloc+1]):
						if j in notLoc:
							W*=-1
						elif j in degreeLoc:
							W*=float(degreeWord[j])
			if senLoc<len(senLoc)-1:
			   i=senLoc[senloc+1]
			senloc+=1
		c2.write(cl[0]+","+cl[1].strip()+","+str(score)+'\n')
