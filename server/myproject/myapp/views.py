from django.http import HttpResponse
from myapp.models import User
import json

def error(level):
	return json.dumps({'error':level})

def login(request):
	if 'name' in request.POST and 'passwd' in request.POST:
		if request.POST['name'] and request.POST['passwd']:
			user = User.objects.filer(name = name, passwd = passwd)
			if user:
				return HttpResponse(error('0'))
			else:
				return HttpResponse(error('1'))
	return HttpResponse(error('2'))

def register(request):
	if 'name' in request.POST and request.POST['name']:
		user = User.objects.filer(name=request.POST['name'])
		if not user:
			try:
				u = User(name = request.POST['name'], 
						passwd = request.POST['passwd'], 
						phone = request.POST['phone'], 
						school = request.POST['school'], 
						email = request.POST['email'], 
						studentNo = request.POST['studentNo'], 
						gender = request.POST['gender'])
				u.save()
				return HttpResponse(error('0'))
			except:
				return HttpResponse(error('1'))
	return HttpResponse(error('1'))
