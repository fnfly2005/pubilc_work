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
from web import form
import os
import sys

try:
    password=sys.argv[2]
except:
    print '请在参数2位置输入mysql连接密码'
    sys.exit()

db = web.database(dbn = 'mysql', port = 3306, host = '127.0.0.1', \
    user = 'fnfly2005', pw = password, db = 'upload_table')

pubhome=os.environ.get('public_home')
render = web.template.render(pubhome + '/base_code/webpy/templates/')

urls = ('/','index')

myform = form.Form(
    form.Textbox("performance_name"),
    form.Textbox("bax",
        form.notnull,
        form.regexp('\d+','Must be a digit'),
        form.Validator('Must be more than 5', lambda x:int(x)>5)),
    form.Textarea('moe'),
    form.Checkbox('curly'),
    form.Dropdown('french', ['mustard', 'fries', 'wine']))

class index:
    def GET(self):
        form = myform()
        # make sure you create a copy of the form by calling it (line above)
        # Otherwise changes will appear globally
        #return render.index(todos,form)
        return render.formtest(form)
    
    def POST(self):
        form = myform()
        if not form.validates():
            return render.formtest(form)
        else:
            # form.d.boe and form['boe'].value are equivalent ways of
            # extracting the validated arguments from the form.
            s=form.d.performance_name
            return "%s" % (s)

if __name__ == "__main__":
    web.internalerror = web.debugerror
    app = web.application(urls, globals())
    app.run()
