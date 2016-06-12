#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import asyncio
import json
import time
import orm
import os
from datetime import datetime
from handlers import cookie2user, COOKIE_NAME
from aiohttp import web
from web_frame import add_routes, add_static
import logging
logging.basicConfig(level=logging.INFO)


# ------------------------------------------拦截器middlewares设置-------------------------
# 日志处理. 这里的handler是auth_factory.auth。一步一步之间关联handler
@asyncio.coroutine
def logger_factory(app, handler):
    @asyncio.coroutine
    def logger(request):
        logging.info("Request: %s %s " % (request.method, request.path))
        logging.info(request.text())
        return (yield from handler(request))
    return logger


# 解析数据
def data_factory(app, handler):
    @asyncio.coroutine
    def parse_data(request):
        if request.method == "POST":
            if request.content_type.startwith("application/json"):
                # request.json方法,读取消息主题,并以utf-8解码
                request.__data__ = yield from request.json()
                logging.info("request json: %s" % str(request.__data__))
            elif request.content_type.startwith("application/x-www-form-urlencoded"):
                request.__data__ = yield from request.host()
                logging.info("request form: %s" % str(request.__data__))
        return (yield from handler(request))
    return parse_data


@asyncio.coroutine
def auth_factory(app, handler):
    @asyncio.coroutine
    def auth(request):
        logging.info("check user: %s %s" % (request.method, request.path))
        request.__user__ = None
        logging.info(request.cookies)
        cookie_str = request.cookies.get(COOKIE_NAME)

        if cookie_str:
            user = yield from cookie2user(cookie_str)
            if user:
                logging.info("set current user: %s" % user.email)
                request.__user__ = user
        logging.info(request.__user__)
        if request.__user__ is None:
            # 需要登录/sign/in 
            # return return web.HTTPFound('/signin')
            pass
        return (yield from handler(request))
    return auth


# 最后构造response的方法。 URL-handler返回处理结果给response
# response_factory拿到经过处理后的对象，经过一系列类型判断，构造出正确web.Response对象
@asyncio.coroutine
def response_factory(app, handler):
    @asyncio.coroutine
    def response(request):
        logging.info("Response Handler...")
        # the handle result
        r = yield from handler(request)
        logging.info('r = %s' % str(r))
        if isinstance(r, web.StreamResponse):
            return r
        # 如果响应结果为字节流，则把字节流塞到response的body里，设置响应类型为流类型，返回
        if isinstance(r, bytes):
            resp = web.Response(body=r)
            resp.content_type = 'application/octet-stream'
            return resp
        if isinstance(r, str):
            if r.startswith('redirect:'):
                # 判断是否需要重定向
                return web.HTTPFound(r[9:])
            resp = web.Response(body=r.encode('utf-8'))
            resp.content_type = 'text/html;charset=utf-8'
        # 最多应该用到的东西
        if isinstance(r, dict):
            resp = web.Response(
                body=json.dumps(
                    r,
                    ensure_ascii=False,
                    default=lambda o: o.__dict__
                ).encode('utf-8')
            )
            resp.content_type = "application/json;charset=utf-8"
            return resp
        if isinstance(r, int) and 100 <= r < 600:
            return web.Response(status=r)
        if isinstance(r, tuple) and len(r) == 2:
            status, message = r
            if isinstance(status, int) and 100 <= status < 600:
                return web.Response(status=status, text=str(message))
            resp = web.Response(body=str(r).encode('utf-8'))
            resp.content_type = 'text/plain;charset=utf-8'
            return resp
    return response


def datetime_filter(t):
    delta = int(time.time() - t)
    if delta < 60:
        return u'1分钟前'
    if delta < 3600:
        return u'%s分钟前' % (delta // 60)
    if delta < 86400:
        return u'%s小时前' % (delta // 3600)
    if delta < 604800:
        return u'%s天前' % (delta // 86400)
    dt = datetime.fromtimestamp(t)
    return u'%s年%s月%s日' % (dt.year, dt.month, dt.day)


@asyncio.coroutine
def init(loop):
    yield from orm.create_pool(
        loop=loop,
        host="115.159.219.141",
        port=3306,
        user="root",
        password="wxd",
        db="webApp",
        autocommit=True
    )
    app = web.Application(loop=loop, middlewares=[logger_factory, auth_factory, response_factory])
    add_routes(app, 'handlers')
    add_static(app)
    srv = yield from loop.create_server(app.make_handler(), '127.0.0.1', 8000)
    logging.info('server started at http://127.0.0.1:8000...')
    return srv

loop = asyncio.get_event_loop()
loop.run_until_complete(init(loop))
loop.run_forever()
