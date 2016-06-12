#! /usr/bin/env python3
# *_ coding: utf-8_*_

import asyncio
import aiomysql
import orm
from models import User


@asyncio.coroutine
def test_remove(loop):
    yield from orm.create_pool(loop, user='root', password='wxd', db='webApp')
    # 用id初始化一个实例对象
    u = User()
    yield from u.remove()


def test_save(loop):
    yield from orm.create_pool(loop=loop, host='115.159.219.141', user='wxd', password='wxd', db='webApp')
    u = User(studentNo='201421010521', name='wxd', email='xx@example.com', passwd='123456789', phone='13-18260096', gender=True)
    yield from u.save()

loop = asyncio.get_event_loop()
loop.run_until_complete(test_save(loop))
__pool = orm.__pool
__pool.close()
loop.run_until_complete(__pool.wait_closed())
loop.close()