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
    form.Textbox("项目名称 *",form.notnull),
    form.Textbox("销售额 *",
        form.notnull,
        form.regexp('\d+','Must be a digit'),
        form.Validator('Must be more than 5', lambda x:int(x)>5)),
    form.Textbox("打款日期 *",form.notnull),
    form.Textbox("负责BD *",form.notnull),
    form.Dropdown('打款方式 *', ['公对公', '私对公']),
    form.Textbox("项目ID"),
    form.Textbox("出票量",
        form.regexp('\d+','Must be a digit'),
        form.Validator('Must be more than 5', lambda x:int(x)>5)),
    form.Textbox("分销方"),
    form.Textbox("佣金率"),
    form.Textbox("猫眼订单ID"))

class index:
    def GET(self):
        todos = db.query("select * from detail_myshow_saleoffline")
        form = myform()
        return render.index(todos,form)

class add:
    def POST(self):
        form = myform()
        n = db.insert('sale_offline',performance_name=form['项目名称 *'].value)
        raise web.seeother('/')

if __name__ == "__main__":
    app = web.application(urls, globals())
    app.run()
