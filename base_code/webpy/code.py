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

render = web.template.render('templates/')

urls = (
    '/(.*)','index'
)

class index:
    def GET(self,name):
        return render.index(name)

if __name__ == "__main__":
    app = web.application(urls, globals())
    app.run()
