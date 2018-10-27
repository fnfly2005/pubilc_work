#!/usr/bin/python
#coding:utf-8
##################################
'''
Path: 
Description: webpy
Date:  2018-10-17
Version: v1.0
'''
##################################
import web
import sys

try:
    password=sys.argv[2]
except:
    print '请在参数2位置输入mysql连接密码'
    sys.exit()

db = web.database(dbn = 'mysql', port = 3306, host = '127.0.0.1', \
    user = 'fnfly2005', pw = password, db = 'webpy')
render = web.template.render('templates/')
urls = (
    '/','index',
    '/add','add'
)

class index:
    def GET(self):
        todos = db.select('todo')
        return render.index(todos)

class add:
    def POST(self):
        i = web.input()
        n = db.insert('todo',title=i.title)
        raise web.seeother('/')

if __name__ == "__main__":
    app = web.application(urls, globals())
    app.run()
