#!/usr/bin/python
#coding:utf-8
"""
Description: 使用Flask开发web应用
"""

from flask import Flask, render_template, request
from wtforms import Form, TextAreaField, validators

app=Flask(__name__)#使用文件名初始化Flask类

class HelloForm(Form):
    sayhello = TextAreaField('',[validators.DataRequired()])

@app.route('/') #使用route()装饰器来触发函数的URL 
def index():
    form = HelloForm(request.form)
    return render_template('first_app.html',form=form)

@app.route('/hello',methods=['POST'])
def hello():
    form = HelloForm(request.form)
    if request.method == 'POST' and form.validate():
        name = request.form['sayhello']
        return render_template('hello.html',name=name)
    return render_template('first_app.html',form=form)

if __name__ == '__main__':
    app.run(debug=True)#运行app 调试模式
