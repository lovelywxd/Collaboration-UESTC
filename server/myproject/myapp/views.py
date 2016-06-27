#coding:utf-8

from django.http import HttpResponse
from models import User, Promotion
from django.core import serializers
import json

def userLogin(request):
	if 'name' in request.GET and 'passwd' in request.GET:
		name = request.GET['name']
		passwd = request.GET['passwd']
		if name and passwd:
			user = User.objects.filter(name = name, passwd = passwd)
			if user:
				result = {'status': '0', 'data': user.values()[0]}
				return HttpResponse(json.dumps(result)) #登录成功
			else:
				result = {'status': '1', 'data': 'invalid username or pwssword'}
				return HttpResponse(json.dumps(result)) #登录无效
	result = {'status': '2', 'data': 'invalid parameters'}
	return HttpResponse(json.dumps(result)) #无效参数

def userRegister(request):
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

def promotionList(request):
	return HttpResponse(serializers.serialize("json", Promotion.objects.all())[1:-1])

def promotionDetail():
	pass

def searchPromotion():
	pass

def searchHome():
	pass

def favoriteCategory():
	pass

def favoriteBook():
	pass