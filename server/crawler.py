#coding=utf-8
import urllib2
from bs4 import BeautifulSoup

homePage = "http://www.queshu.com"
news = {} #活动：链接

def newsFind():
    try:
        response = urllib2.urlopen(urllib2.Request(homePage))
        soup = BeautifulSoup(response)
        for link in soup.find_all(class_="news_title_top", limit=9):
            news[link.string] = homePage + link.parent["href"]
        for key, value in news.items():
            response = urllib2.urlopen(urllib2.Request(value))
            soup = BeautifulSoup(response)
            for link in soup.find_all(class_="go_btn"):
                if(link.parent["href"][1:5] == "link"):
                    news[key] = homePage + link.parent["href"]
                else:
                    news[key] = link.parent["href"]
    except urllib2.URLError, e:
        print(e.reason)
