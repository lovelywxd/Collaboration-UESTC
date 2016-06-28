#coding=utf-8
import urllib2
import logging
import re
import threading
import time
import json
from bs4 import BeautifulSoup
from apscheduler.schedulers.background import BackgroundScheduler
from models import Promotion, PromotionBookList, BookPriceList

condition = threading.Condition()
sale_list_link_new = {}
sale_list_link_old = {}


def search_home_list_find(book_name):  #主页图书搜索
	home = "https://book.douban.com/subject_search?search_text="
	searchRerult = []
	try:
		response = urllib2.urlopen(urllib2.Request(home + book_name))
		soup = BeautifulSoup(response, "html.parser")
		for subject_item in soup.find_all(class_="subject-item"):
			booSubject = subject_item.contents[1].contents[1]["href"]  #图书主页
			bookImageLink = subject_item.contents[1].contents[1].contents[1]["src"]  #图书图像
			buy_info = subject_item.find(class_="buy-info")
			bookLowestPrice = ""
			if buy_info:
				bookLowestPrice = buy_info.contents[1].string.strip()  #图书最低价
			info = subject_item.find(class_="info")
			bookName = info.contents[1].contents[1]["title"] #图书名称
			bookDetail = info.contents[3].string.strip() #图书详细信息

			d = {"booSubject": booSubject, 
			"bookName": bookName, 
			"bookImageLink": bookImageLink,
			"bookDetail": bookDetail,
			"bookLowestPrice": bookLowestPrice}
			searchRerult.append(d)
		
		return json.dumps(searchRerult, ensure_ascii=False, encoding="utf-8")
	except urllib2.URLError, e:
		print e.reason


def search_home_detail_find(subject): #搜索结果比价
	searchRerult = []
	try:
		response = urllib2.urlopen(urllib2.Request(subject))
		soup = BeautifulSoup(response, "html.parser")
		bookISBN = soup.find(text=re.compile(r"\d{13}"))  #图书ISBN
		if not bookISBN:
			return
		bookISBN = bookISBN.strip()

		response = urllib2.urlopen(urllib2.Request(subject + "buylinks")) #价格对比页
		soup = BeautifulSoup(response, "html.parser")
		buylink_able = soup.find(id="buylink-table")
		if buylink_able:
			tr = buylink_able.find_all("tr")
			if tr:
				for td in tr[1:]: #价格表项
					bookSaler = td.contents[1].contents[0]["src"]
					bookSaler = bookSaler[bookSaler.rfind(r"/") + 1:] #电商图像
					bookCurrentPrice = td.contents[5].contents[1].string #图书价格
					
					d = {"bookISBN": bookISBN, 
					"bookSaler": bookSaler, 
					"bookCurrentPrice": bookCurrentPrice}
					searchRerult.append(d)

		return json.dumps(searchRerult, ensure_ascii=False, encoding="utf-8")
	except urllib2.URLError, e:
		print e.reason


def sale_list_find(): #促销图书列表
	global sale_list_link_old
	global sale_list_link_new
	home = "http://www.queshu.com"
	try:
		sale_list_link_diff = set(sale_list_link_old) - set(sale_list_link_new) #从列表中删除旧活动
		for item in set(sale_list_link_diff):
			result = Promotion.objects.filter(promotionID=item)
			result.delete()
			result = PromotionID.objects.filter(promotionID=item)
			result.delete()

		sale_list_link_diff = set(sale_list_link_new) - set(sale_list_link_old) #添加新活动到列表
		for item in set(sale_list_link_diff):
			promotionID = item
			sale_list_link = sale_list_link_new[item]
			promotionBookSearchLink = sale_list_link + "?c=" #活动图书检索链接

			response = urllib2.urlopen(urllib2.Request(sale_list_link))
			soup = BeautifulSoup(response, "html.parser")
			for jinalou_book_right in soup.find_all(id="jinalou_book_right"):
				xianjia = jinalou_book_right.find(class_="xianjia")
				promotionBookCurrentPrice = xianjia #图书促销价格
				if not promotionBookCurrentPrice: #可能为空
					continue
				promotionBookCurrentPrice = promotionBookCurrentPrice.string

				promotionBookPrice = jinalou_book_right.contents[3].contents[0].string.encode('utf-8') #图书定价
				promotionBookPrice = promotionBookPrice[promotionBookPrice.find("：") + 3:]

				book = home + jinalou_book_right.contents[0].contents[0]["href"]  #活动图书详情
				response = urllib2.urlopen(urllib2.Request(book))
				soup = BeautifulSoup(response, "html.parser")

				promotionBookISBN = soup.find(text=re.compile(r"\d{13}"))[-13:]  #图书ISBN
				for price_item in soup.find_all(class_="price_item"): #图书价格列表
					book_site = home + price_item.find(class_="book_site").contents[0].contents[0]["src"]
					book_price = price_item.find(class_="book_price_price")
					if not book_price: #可能为空
						continue

					bookSaler = book_site
					bookCurrentPrice = book_price.contents[0]
					if repr(bookCurrentPrice)[0] != 'u': #无规则数据
						continue
					bookCurrentPrice = bookCurrentPrice + book_price.contents[1].string

					result = BookPriceList(
						bookISBN		 = promotionBookISBN,
						bookSaler		= bookSaler,
						bookCurrentPrice = bookCurrentPrice)
					result.save()

				result = PromotionBookList(
						promotionID				= promotionID,
						promotionBookISBN		 = promotionBookISBN,
						promotionBookPrice		= promotionBookPrice,
						promotionBookCurrentPrice = promotionBookCurrentPrice,
						promotionBookSearchLink	= promotionBookSearchLink)
				result.save()
		sale_list_link_old = sale_list_link_new
		sale_list_link_new = {}
	except urllib2.URLError, e:
		print e.reason


def news_title_find(): #热门资讯
	home = "http://www.queshu.com"
	try:
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
	global sale_list_link_new
	home = "http://www.queshu.com/sale/"
	try:
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

				if promotionDeadline: #可能为空
					promotionDeadline = promotionDeadline.encode('utf-8')
				promotionID=promotionLink[-5:]
				result = Promotion(
					promotionID		= promotionID.encode('utf-8'),
					promotionCompany  = promotionCompany.encode('utf-8'), 
					promotionName	 = promotionName.encode('utf-8'), 
					promotionDeadline = promotionDeadline, 
					promotionLink	 = promotionLink.encode('utf-8'))
				result.save()

				font_13_bold = news_sale_detail.find(href=re.compile("sale_list"))  #参加活动图书列表
				if font_13_bold:
					sale_list_link_new[promotionID] = home[:-6] + font_13_bold["href"]
	except urllib2.URLError, e:
		print e.reason

class Producer(threading.Thread):
	def run(self):
		while True:
			if condition.acquire():
				if sale_list_link_new:
					condition.wait()
				else:
					news_sale_title_find()
					condition.notify()
					condition.release()
					time.sleep(30)


class Consumer(threading.Thread):
	def run(self):
		while True:
			if condition.acquire():
				if not sale_list_link_new:
					condition.wait()
				else:
					sale_list_find()
					condition.notify()
					condition.release()


def start_crawler():
	# sched = BackgroundScheduler()
	# sched.add_job(news_title_find, 'interval', seconds=30)
	# sched.add_job(news_sale_title_find, 'interval', seconds=30)
	# sched.add_job(sale_list_find, 'interval', seconds=60)
	# sched.start()
	p = Producer()
	c = Consumer()
	p.setDaemon(True)
	c.setDaemon(True)
	p.start()
	c.start()