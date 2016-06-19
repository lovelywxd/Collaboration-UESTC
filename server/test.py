#coding:utf-8

import requests

payload = {
    'name': 'shuaihan',
    'passwd': 'admin',
    'phone': '15682017891',
    'school': 'uestc',
    'email': '466629332@qq.com',
    'studentNo': '201421010517',
    'gender': '1'
}

r = requests.get("http://localhost:8000/register/", params=payload)
print r.url
print r.status_code