#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
URL handlers.
"""
import time
import hashlib
import asyncio
import logging
import re
import json
from aiohttp import web
from models import User
from config import configs
from web_frame import get, post
from apis import APIError, APIResourceNotFoundError, APIValueError, APIPermissionError

_COOKIE_KEY = configs.session.secret  # cookie密钥,作为加密cookie的原始字符串的一部分
COOKIE_NAME = 'web_app_session'  # cookie名,用于设置cookie
_RE_EMAIL = _RE_EMAIL = re.compile(r'^[a-z0-9\.\-_]+@[a-z0-9\-_]+(\.[a-z0-9\-_]+){1,4}$')
_RE_SHA1 = re.compile(r'[0-9a-f]{40}$')

def check_admin(request):
    if request.__user__ is None:
        return APIPermissionError()


def user2cookie(user, max_age):
    expires = str(int(time.time() + max_age))
    s = '%s-%s-%s-%s' % (user.name, user.passwd, expires, _COOKIE_KEY)
    # 生成加密的字符串,并与用户id,失效时间共同组成cookie
    l = [user.name, expires, hashlib.sha1(s.encode("utf-8")).hexdigest()]
    return "-".join(l)


# 解密cookie.根据cookie字符串，避免重复登录。
# 目的：验证cookie,就是为了验证当前用户是否仍登录
@asyncio.coroutine
def cookie2user(cookie_str):
    """Parse cookie and load user if cookie is valid"""
    if not cookie_str:
        return None
    try:
        l = cookie_str.split("-")
        if len(l) != 3:
            return None
        uname, expires, sha1s = l
        # 若失效时间小于当前时间,cookie失效
        if int(expires) < time.time():
            return None
        user = yield from User.find(uname)
        if user is None:
            return None
        s = "%s-%s-%s-%s" % (uname, user.passwd, expires, _COOKIE_KEY)
        if sha1s != hashlib.sha1(s.encode("utf-8")).hexdigest():
            logging.info("invalid sha1")
            return None
        user.passwd = '******'
        return user
    except Exception as e:
        logging.exception(e)
        return None


@get('/signin')
def signin():
    pass


@get('/signout')
def signout(request):
    referer = request.headers.get('Referer')
    r = web.HTTPFound(referer or '/')
    # 清理掉cookie用户信息数据
    r.set_cookie(COOKIE_NAME, '-deleted-', max_age=0, httponly=True)
    logging.info('user signed out.')
    return r


@get('/api/users')
def api_get_users():
    """
    Web API test.
    get all users information: have registered.
    """
    users = yield from User.findAll(orderBy='studentNo')
    logging.info(users)
    for u in users:
        u.passwd = '******'
    return dict(users=users)

# 需要改动
@post('/api/users')
def api_register_user(*, email, name, passwd,studentNo,phone,gender):
    """
    save in table: USER
    登录之后，可以增加邮箱激活模块，邮件激活。
    """
    result = False
    if not name or not name.strip():
        raise APIValueError("name")
    if not email or not _RE_EMAIL.match(email):
        raise APIValueError("email")
    # some question ? why.
    if not passwd or not _RE_SHA1.match(passwd):
        raise APIValueError("passwd")
    users = yield from User.findAll('name=?', [name])
    if len(users) > 0:
        raise APIError('register:failed', 'email', 'Email is already in use.')
    sha1_passwd = '%s:%s' % (name, passwd)
    user = User(
        studentNo=studentNo,
        name=name.strip(),
        email=email,
        passwd=hashlib.sha1(sha1_passwd.encode('utf-8')).hexdigest(),
        phone=phone,
        gender=gender
        # image="http://www.gravatar.com/avatar/%s?d=mm&s=120" % hashlib.md5(email.encode('utf-8')).hexdigest(),
        # image="about:blank"
    )
    yield from user.save()
    result = True
    r = web.Response()
    r.set_cookie(COOKIE_NAME, user2cookie(user, 86400), max_age=86400, httponly=True)  # 86400s=24h
    user.passwd = '*****'
    r.content_type = 'application/json'
    r.body = json.dumps(dict(result=result)).encode('utf-8')
    logging.info(r.body)
    return r


@post('/api/authenticate')
def authenticate(*, name, passwd):
    """
    通过邮箱与密码验证登录
    提交之前，可以在本地或者远端进行合法性验证
    """
    result = False
    if not name:
        raise APIValueError("name", "Invalid name")
    if not passwd:
        raise APIValueError("passwd", "Invalid password")
    users = yield from User.findAll("name=?", [name])
    if len(users) == 0:
        raise APIValueError("name", "name not exits")
    user = users[0]
    # sha1_passwd = '%s:%s' % (uid, passwd)
    sha1 = hashlib.sha1()
    sha1.update(user.name.encode("utf-8"))
    sha1.update(b":")
    sha1.update(passwd.encode("utf-8"))
    logging.info("55555555555555555555555555555555555555555")
    if user.passwd != sha1.hexdigest():
        raise APIValueError("passwd", "Invalid password")
    r = web.Response()
    r.set_cookie(COOKIE_NAME, user2cookie(user, 86400), max_age=86400, httponly=True)
    user.passwd = "*****"
    r.content_type = "application/json"
    result = True
    # r.body = json.dumps(user, ensure_ascii=False).encode("utf-8")
    r.body = json.dumps(dict(result=result)).encode("utf-8")
    logging.info(r.body)
    return r


@get('/api/act/{id}')
def api_get_act(*, id):
    pass
