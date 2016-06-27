#coding:utf-8

from django.http import HttpResponse
from models import User, Promotion, UserFavourite, BookInformation
from django.core import serializers
from django.views.decorators.http import require_POST
import json
import re
import hashlib
import time
import logging

from django.views.decorators.csrf import csrf_exempt

#=============================================================

_COOKIE_KEY = "myapp"
COOKIE_NAME = "myapp_session"
_RE_EMAIL = re.compile(r'^[a-zA-Z0-9\.\-_]+@[a-zA-Z0-9\-_]+(\.[a-zA-Z0-9\-_]+){1,4}$')
_RE_PHONE = re.compile(r'^(1[345678]\d{9})$')
_RE_SHA1 = re.compile(r'[0-9a-f]{1,40}$')


# Create your views here

def user_auth(request):
    logging.info("check user: %s %s", request.method, request.path)
    request.user = None
    logging.info(request.cookies)
    cookie_str = request.cookies.get(COOKIE_NAME)
    if cookie_str:
        user = cookie2user(cookie_str)
        if user:
            logging.info("set current user: %s" % user.name)
            request.user = user
            return True
    return False


def user2cookie(username, user, max_age):
    expires = str(int(time.time() + max_age))
    cookie_str = '%s-%s-%s-%s' % (username, user['password'], expires, _COOKIE_KEY)
    cookie_list = [username, expires, hashlib.sha1(cookie_str.encode("utf-8")).hexdigest()]
    return "-".join(cookie_list)


def cookie2user(cookie_str):
    if not cookie_str:
        return None
    try:
        cookie_list = cookie_str.split("_")
        if len(cookie_list) != 3:
            return None
        username, expires, sha1s = cookie_list
        if int(expires) < time.time():
            return None
        # name:email, phone, name
        if _RE_EMAIL.match(username):
            user = User.objects.get(email=username)
        elif len(username) == 11 and _RE_PHONE.match(username):
            user = User.objects.get(phone=username)
        else:
            user = User.objects.get(name=username)
        cookie_str = "%s-%s-%s-%s" % (username, user.passwd, expires, _COOKIE_KEY)
        if sha1s != hashlib.sha1(cookie_str.encode("utf-8")).hexdigest():
            logging.info("invalid sha1")
            return None
        return user
    except Exception as e:
        logging.exception(e)
        return None


def check_password(users, username, password):
    user = users.values()[0]
    sha1 = hashlib.sha1()
    sha1.update(username.encode("utf-8"))
    sha1.update(b":")
    sha1.update(password.encode("utf-8"))
    if user.passwd != sha1.hexdigest():
        return False
    return True


def authenticate(username=None, password=None):
    if username:
        if _RE_EMAIL.match(username):
            try:
                users = User.objects.filter(email=username)
                if check_password(users, username, password):
                    return users
            except User.DoesNotExist:
                return None
        elif len(username) == 11 and _RE_PHONE.match(username):
            try:
                users = User.objects.filter(phone=username)
                if check_password(users, username, password):
                    return users
            except User.DoesNotExist:
                return None
        else:
            try:
                users = User.objects.filter(name=username)
                if check_password(users, username, password):
                    return users
            except User.DoesNotExist:
                return None
    else:
        return None


@require_POST
@csrf_exempt
def user_login(request):
    username = request.POST['name']
    password = request.POST['passwd']
    if username == "" or username.isspace():
        result = {"status": '1', "data": "username can't empty"}
        return HttpResponse(json.dumps(result, ensure_ascii=False), content_type="application/json")
    if password == "" or password.isspace():
        result = {"status": '1', "data": "password can't be empty"}
        return HttpResponse(json.dumps(result, ensure_ascii=False), content_type="application/json")
    user = authenticate(username=username, password=password).values()[0]
    if user is not None:
        result = {"status": '0', "data": user.values()[0]}
        response = HttpResponse(json.dumps(result, ensure_ascii=False), content_type="application/json")
        response.set_cookie(COOKIE_NAME, user2cookie(username, user, 6220800), max_age=6220800, httponly=True)
        return response
    else:
        result = {"status": '1', "data": "invalid username or password"}
        return HttpResponse(json.dumps(result, ensure_ascii=False), content_type="application/json")


@require_POST
@csrf_exempt
def user_register(request):
    username = request.POST['name']
    password = request.POST['passwd']
    email = request.POST['email']
    result = {"status": '2', "data": "invalid parameters"}
    if not username or not username.strip():
        result["data"] = "invalid username"
        return HttpResponse(json.dumps(result, ensure_ascii=False), content_type="application/json")
    if not password:
        result["data"] = "invalid password"
        return HttpResponse(json.dumps(result, ensure_ascii=False), content_type="application/json")
    if not email or not _RE_EMAIL.match(email):
        result["data"] = "invalid email"
        return HttpResponse(json.dumps(result, ensure_ascii=False), content_type="application/json")
    user = User.objects.filter(username=username)
    sha1_passwd = '%s:%s' % (username, password)
    if not user:
        try:
            u = User(username=username,
                     password=hashlib.sha1(sha1_passwd.encode('utf-8')).hexdigest(),
                     phone=request.POST['phone'],
                     email=request.POST['email'],
                     studentNo=request.POST['studentNo'],
                     gender=request.POST['gender'],
                     school=request.POST['school'])
            u.save()
            result["status"] = '0'
            result["data"] = "register success"
            response = HttpResponse(json.dumps(result, ensure_ascii=False), content_type="application/json")
            response.set_cookie(COOKIE_NAME, user2cookie(username, user.values()[0], 6220800), max_age=6220800, httponly=True)
            return response
        except Exception as e:
            logging.info(e)
            result['data'] = "exception: %s" % e
            return HttpResponse(json.dumps(result, ensure_ascii=False), content_type="application/json")
    result['data'] = "username have been registered"
    return HttpResponse(json.dumps(result, ensure_ascii=False), content_type="application/json")

@csrf_exempt
def user_logout(request):
    result = {'status': '0', 'data': 'logout success'}
    response = HttpResponse(json.dumps(result, ensure_ascii=False), content_type="application/json")
    response.set_cookie(COOKIE_NAME, "-deleted-", max_age=0, httponly=True)
    return response


def get_favourite(request):
    favourite_list = []
    if not user_auth(request):
        result = {"status": '2', "data": "user need login"}
        return HttpResponse(json.dumps(result, ensure_ascii=False), content_type="application/json")
    userfavourite = UserFavourite.objects.filter(name=request.user.name)
    if len(userfavourite) == 0:
        result = {"status": '0', "data": "UserFavourite is empty"}
        return HttpResponse(json.dumps(result, ensure_ascii=False), content_type="application/json")
    for favourite in userfavourite:
        try:
            bookinfor = BookInformation.objects.get(favourite.ISBN)
            favourite_list.append(bookinfor.bookName)
        except BookInformation.DoesNotExist:
            # BookInformation don't have this book.
            pass
    result = {"username": request.user.name, "favourite_list": favourite_list}
    return HttpResponse(json.dumps(result, ensure_ascii=False), content_type="application/json")

#=============================================================

def promotionList(request):
	return HttpResponse(serializers.serialize("json", Promotion.objects.all())[1:-1])

def promotionDetail():
	pass

def searchPromotion():
	pass

def searchHome():
	pass

def favoriteBook():
	pass