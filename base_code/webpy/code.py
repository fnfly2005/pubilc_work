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

db = web.database(dbn='mysql',user='fannian',pw='I$p4xuzRl0fUJ6JZ',db='webpy')
render = web.template.render('templates/')

urls = (
    '/','index',
)

class index:
    def GET(self):
        todos = db.select
        return render.index(name)

if __name__ == "__main__":
    app = web.application(urls, globals())
    app.run()
