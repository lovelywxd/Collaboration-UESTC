#coding:utf-8

from django.http import HttpResponse
from models import User
import json

def login(request):
	if 'name' in request.GET and 'passwd' in request.GET:
		name = request.GET['name']
		passwd = request.GET['passwd']
		if name and passwd:
			user = User.objects.filter(name = name, passwd = passwd)
			if user:
				result = {'status': '0', 'data': user.values()[0]}
				return HttpResponse(json.dumps(result)) #登录成功
			else:
				result = {'status': '1', 'data': 'invalid username'}
				return HttpResponse(json.dumps(result)) #登录无效
	result = {'status': '2', 'data': 'invalid parameters'}
	return HttpResponse(json.dumps(result)) #无效参数

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
				result = {'status': '0', 'data': user.values()[0]}
				return HttpResponse(json.dumps(result)) #注册成功
			except:
				result = {'status': '2', 'data': 'invalid parameters'}
				return HttpResponse(json.dumps(result)) #无效参数
		else:
			result = {'status': '1', 'data': 'this username has been registered'}
			return HttpResponse(json.dumps(result)) #已经注册
	result = {'status': '2', 'data': 'invalid parameters'}
	return HttpResponse(json.dumps(result)) #无效参数

def news(request):
	return HttpResponse("news")

def sale(request):
	return HttpResponse("sale")