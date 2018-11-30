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
    form.Textbox('项目名称*',
        form.notnull
        ),
    form.Textbox('项目ID',
        form.regexp('\d+','必须为数字'),
        form.Validator('必须为正整数', lambda x:int(x)>0),
        value=0),
    form.Textbox('销售额*',
        form.notnull,
        form.regexp('\d+','必须为数字'),
        form.Validator('必须为正数', lambda x:float(x)>0)),
    form.Textbox('出票量',
        form.regexp('\d+','必须为数字'),
        form.Validator('必须为正整数', lambda x:int(x)>0),
        value=1
        ),
    form.Textbox('打款日期*',
        form.notnull
        ),
    form.Textbox('负责BD*',
        form.notnull
        ),
    form.Dropdown('打款方式*', ['公对公', '私对公']),
    form.Textbox('分销方'),
    form.Textbox('佣金比例',
    value=0)
    )

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
            n = db.insert('sale_offline',
                performance_name=form['项目名称*'].value,
                totalprice=form['销售额*'].value,
                dt=form['打款日期*'].value,
                bd_name=form['负责BD*'].value,
                pay_type=form['打款方式*'].value)
            raise web.seeother('/')

if __name__ == "__main__":
    web.internalerror = web.debugerror
    app = web.application(urls, globals())
    app.run()
