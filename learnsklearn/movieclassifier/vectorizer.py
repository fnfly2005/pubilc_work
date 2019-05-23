#!/usr/bin/python
#codoing:utf-8
#序列化通过scikit-learn拟合的模型
from sklearn.feature_extraction.text import HashingVectorizer
import re
import os
import pickle

cur_dir = os.path.dirname(__file__)
stop = pickle.load(open(os.path.join(cu_dir,'pkl_objects','stopwords.pkl'),'rb'))

def tokenizer(text):
    '''清洗数据，过滤停用词,返回分词列表'''
    text = re.sub('<[^>]*>','',text)
    emoticons = re.findall('(?::|;|=)(?:-)?(?:\)|\(|D|P)',text.lower())
    text = re.sub('[\W]+',' ',text.lower())+ ' '.join(emoticons).replace('-','')
    tokenized = [ w for w in text.split() if w not in stop]
    return tokenized

vect = HashingVectorizer(decode_error='ignore',n_features=2**21,preprocessor=None,tokenizer=tokenizer)
