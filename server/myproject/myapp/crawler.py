#coding=utf-8
import urllib2
import logging
from bs4 import BeautifulSoup
from apscheduler.schedulers.background import BackgroundScheduler
from models import News, Promotion

def news_title_find(): #热门资讯
    try:
        home = "http://www.queshu.com"
        response = urllib2.urlopen(urllib2.Request(home))
        soup = BeautifulSoup(response, "html.parser")
        for news_book in soup.find_all(class_="news_book"):
            news_title = news_book.contents[0]
            news_left_line1 = news_book.contents[1]

            name = news_title.contents[0].contents[0] #活动名称
            link = home + "/link" + news_title.contents[0]["href"] #活动链接
            start = news_left_line1.contents[0].contents[0] #活动开始时间
            end = news_left_line1.contents[0].contents[2] #活动结束时间

            result = News(name=name, link=link, start=start, end=end)
            result.save()
    except urllib2.URLError, e:
        print e.reason

def news_sale_title_find(): #图书促销
    try:
        home = "http://www.queshu.com/sale/"
        response = urllib2.urlopen(urllib2.Request(home))
        soup = BeautifulSoup(response, "html.parser")
        for news_sale_detail in soup.find_all(class_="news_sale_detail"):
            promotionCompany = news_sale_detail.contents[0].contents[0] #电商名字
            promotionDeadline = news_sale_detail.contents[1].string #活动结束时间
            for news_sale_title in news_sale_detail.find_all(class_="news_sale_title"): #活动链接
                promotionName = news_sale_title.contents[0].contents[0] #活动名称
                promotionLink = news_sale_title.contents[0]["href"]
                if promotionLink[1:5] == "link":
                    promotionLink = home[:-5] + promotionLink

                if promotionDeadline: #有可能为空
                    promotionDeadline = promotionDeadline.encode('utf-8')
                result = Promotion(promotionID=promotionLink[-5:].encode('utf-8'),
                    promotionCompany=promotionCompany.encode('utf-8'), 
                    promotionName=promotionName.encode('utf-8'), 
                    promotionDeadline=promotionDeadline, 
                    promotionLink=promotionLink.encode('utf-8'))
                result.save()
    except urllib2.URLError, e:
        print e.reason

def start_crawler():
    sched = BackgroundScheduler()
    # sched.add_job(news_title_find, 'interval', seconds=30)
    sched.add_job(news_sale_title_find, 'interval', seconds=30)
    sched.start()

'''
if __name__ == "__main__":
    start_crawler()
'''