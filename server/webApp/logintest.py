import requests

payload = {
    'name': '123777d',
    'passwd': 'ddddsfdf',
    'phone': '13017773',
    'email': '3553772s@qq.com',
    'studentNo': '1221212121',
    'gender': '1',
    'school': ''
    }
# 8213d5d09cb0e30cd4ae7b0eb784298e73a393fe
# 8213d5d09cb0e30cd4ae7b0eb784298e73a393fe
URL = "http://127.0.0.1:8000/user/login/"

res = requests.post(URL, payload)

print(res.text)
print(res.cookies)
