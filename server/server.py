#coding:utf-8
import crawler, database
import json

if __name__ == "__main__":
    # news_find()
    # for key, value in news.items():
    #     print key, value
    database.user_info_create()
    school = "电子科技大学"
    database.user_info_insert("shuaihan", "123456", "15682017891", school)
    print database.user_info_select("shuaihan")
