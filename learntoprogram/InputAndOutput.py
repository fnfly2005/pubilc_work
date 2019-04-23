#!/usr/bin/python
#coding:utf-8
"""
Description: 文件的读取和写入
"""
import nltk
def inputAndOutput(file_name):
    with open(file_name, 'w') as f:
        words = set(nltk.corpus.genesis.words('english-kjv.txt'))
        for word in sorted(words):
            f.write(word + "\n")

if __name__ == '__main__':
    inputAndOutput('Downloads/test.txt')
