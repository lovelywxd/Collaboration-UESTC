#coding=utf-8
import database
import urllib2
from bs4 import BeautifulSoup

news = {} #活动：链接

def news_find():
    temp = {} #CAS
    try:
        home = "http://www.queshu.com"
        response = urllib2.urlopen(urllib2.Request(home))
        soup = BeautifulSoup(response)
        for link in soup.find_all(class_="news_title_top", limit=9):
            temp[link.string] = home + link.parent["href"]
        for key, value in temp.items():
            response = urllib2.urlopen(urllib2.Request(value))
            soup = BeautifulSoup(response)
            for link in soup.find_all(class_="go_btn"):
                if(link.parent["href"][1:5] == "link"):
                    temp[key] = home + link.parent["href"]
                else:
                    temp[key] = link.parent["href"]
        news = temp
    except urllib2.URLError, e:
        print(e.reason)

def news_update():
    pass
