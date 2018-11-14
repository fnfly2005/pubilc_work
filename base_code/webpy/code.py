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
from web import form
import os

pubhome=os.environ.get('public_home')

try:
    password=sys.argv[2]
except:
    print '请在参数2位置输入mysql连接密码'
    sys.exit()

db = web.database(dbn = 'mysql', port = 3306, host = '127.0.0.1', \
    user = 'fnfly2005', pw = password, db = 'upload_table')
render = web.template.render(pubhome + '/base_code/webpy/templates/')
urls = (
    '/','index',
    '/add','add'
)

myform = form.Form(
    #form.Textbox("boe"),
    form.Textbox("performance_name"),
    form.Textbox("performance_id"),
    form.Textbox("totalprice",
        form.notnull,
        form.regexp('\d+','Must be a digit'),
        form.Validator('Must be more than 5', lambda x:int(x)>5)),
    form.Textarea('moe'),
    form.Checkbox('curly'),
    form.Dropdown('french', ['mustard', 'fries', 'wine']))

class index:
    def GET(self):
        todos = db.query("select * from detail_myshow_saleoffline")
        form = myform()
        return render.index(todos,form)

class add:
    def POST(self):
        i = web.input()
        n = db.insert('todo',performance_name=i.performance_name)
        raise web.seeother('/')

if __name__ == "__main__":
    app = web.application(urls, globals())
    app.run()
