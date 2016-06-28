# coding: UTF-8
import requests

payload = {
    "bookname": "wxd"
    # 'name': 'wxd',
    # 'passwd': '123456dd',
    # 'phone': '13644111241',
    # 'email': '3544221214d@163.com',
    # 'studentNo': '1221212121',
    # 'gender': '1',
    # 'school': '电子科技大学'
    }
# 8213d5d09cb0e30cd4ae7b0eb784298e73a393fe
# 8213d5d09cb0e30cd4ae7b0eb784298e73a393fe
URL = "http://115.159.219.141:8000/favourite/add/"

res = requests.post(URL, payload)

print(res.text.encode('utf-8'))
