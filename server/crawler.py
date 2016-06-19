#coding=utf-8
import urllib2
from bs4 import BeautifulSoup


def news_title_top_find(): #热门资讯，前9条
    global news_title_top
    try:
        temp = {}
        home = "http://www.queshu.com"
        response = urllib2.urlopen(urllib2.Request(home))
        soup = BeautifulSoup(response)
        for target in soup.find_all(class_="news_title_top", limit=9):
            temp[target.string] = home + target.parent["href"]
        for key, value in temp.items():
            response = urllib2.urlopen(urllib2.Request(value))
            soup = BeautifulSoup(response)
            for target in soup.find_all(class_="go_btn", limit=1):
                if target.parent["href"][1:5] == "link":
                    temp[key] = home + target.parent["href"]
                else:
                    temp[key] = target.parent["href"]

        for name, link in temp.items():
            print name, link
    except urllib2.URLError, e:
        print e.reason


def news_title_find(): #热门资讯
    try:
        home = "http://www.queshu.com"
        response = urllib2.urlopen(urllib2.Request(home))
        soup = BeautifulSoup(response)
        for news_book in soup.find_all(class_="news_book"):
            news_title = news_book.contents[0]
            news_left_line1 = news_book.contents[1]

            name = news_title.contents[0].contents[0] #活动名称
            link = home + "/link" + news_title.contents[0]["href"] #活动链接
            start = news_left_line1.contents[0].contents[0] #活动开始时间
            end = news_left_line1.contents[0].contents[2] #活动结束时间

            print name, start, end, link
    except urllib2.URLError, e:
        print e.reason

def news_sale_title_find(): #图书促销
    global news_sale_title
    try:
        home = "http://www.queshu.com/sale/"
        response = urllib2.urlopen(urllib2.Request(home))
        soup = BeautifulSoup(response)
        for news_sale_detail in soup.find_all(class_="news_sale_detail"):
            company = news_sale_detail.contents[0].contents[0] #电商名字
            end = news_sale_detail.contents[1].string #结束时间
            for news_sale_title in news_sale_detail.find_all(class_="news_sale_title"): #活动链接
                name = news_sale_title.contents[0].contents[0] #活动名称
                link = news_sale_title.contents[0]["href"]
                if link[1:5] == "link":
                    link = home[:-5] + link

                print company, name, end, link
    except urllib2.URLError, e:
        print e.reason


if __name__ == "__main__":
    print '+' * 100
    news_title_top_find()

    print '+' * 100
    news_title_find()

    print '+' * 100
    news_sale_title_find()
