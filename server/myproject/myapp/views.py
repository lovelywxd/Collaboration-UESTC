#coding:utf-8

from django.http import HttpResponse
from myapp.models import User
import json

def error(level):
	return json.dumps({'error':level})

def login(request):
	if 'name' in request.GET and 'passwd' in request.GET:
		name = request.GET['name']
		passwd = request.GET['passwd']
		if name and passwd:
			user = User.objects.filter(name = name, passwd = passwd)
			if user:
				return HttpResponse(error('0')) #登录成功
			else:
				return HttpResponse(error('1')) #登录无效
	return HttpResponse(error('2')) #无效参数

def register(request):
	if 'name' in request.GET and request.GET['name']:
		user = User.objects.filter(name=request.GET['name'])
		if not user:
			try:
				u = User(name = request.GET['name'], 
						passwd = request.GET['passwd'], 
						phone = request.GET['phone'], 
						school = request.GET['school'], 
						email = request.GET['email'], 
						studentNo = request.GET['studentNo'], 
						gender = request.GET['gender'])
				u.save()
				return HttpResponse(error('0')) #注册成功
			except:
				return HttpResponse(error('1')) #无效参数
		else:
			return HttpResponse(error('2')) #已经注册
	return HttpResponse(error('1')) #无效参数

def news(request):
	return HttpResponse("news")

def sale(request):
	return HttpResponse("sale")

'''
u = User(name = 'shuaihan', passwd = 'admin', phone = '15682017891', school = 'uestc', email = '466629332@qq.com', studentNo = '201421010517', gender = '1')
u.save()
'''