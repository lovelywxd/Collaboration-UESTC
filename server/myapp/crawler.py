#coding=utf-8

import urllib2
import logging
import re
import threading
import time
import json

from bs4 import BeautifulSoup
from selenium import webdriver
from apscheduler.schedulers.background import BackgroundScheduler
from models import Promotion, PromotionBookList, BookPriceList

condition = threading.Condition()
sale_list_link_new = {}
sale_list_link_old = {}

def search_home_list_find(book_name):  #主页图书搜索，结果列表
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

			d = {
			"booSubject": booSubject, 
			"bookName": bookName, 
			"bookImageLink": bookImageLink,
			"bookDetail": bookDetail,
			"bookLowestPrice": bookLowestPrice}
			searchRerult.append(d)
		
		return json.dumps(searchRerult, ensure_ascii=False, encoding="utf-8")
	except urllib2.URLError, e:
		print e.reason


def search_home_detail_find(subject): #主页图书搜索，图书价格信息
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
					bookSaler = td.contents[1].contents[0]["src"] #电商图像
					# bookSaler = bookSaler[bookSaler.rfind(r"/") + 1:] 
					bookLink = td.contents[3].contents[1]["href"] #电商图书直达
					bookCurrentPrice = td.contents[5].contents[1].string #电商图书价格
					
					d = {
					"bookISBN": bookISBN, 
					"bookSaler": bookSaler, 
					"bookCurrentPrice": bookCurrentPrice, 
					"bookLink": bookLink}
					searchRerult.append(d)

		return json.dumps(searchRerult, ensure_ascii=False, encoding="utf-8")
	except urllib2.URLError, e:
		print e.reason


def search_promotion_list_find(bookName, promotionID): #活动图书搜索，结果列表
	searchRerult = []
	try:
		promotionSearchLink = Promotion.objects.filter(promotionID=promotionID)
		if not promotionSearchLink: #如果当前活动无列表可查询
			return "there is no promotion list"

		promotionSearchLink = promotionSearchLink[0].promotionSearchLink
		print promotionSearchLink
		# dir = r"D:\chromedriver" #浏览器驱动路径
		# driver = webdriver.Chrome(dir)
		driver = webdriver.PhantomJS()
		driver.get(promotionSearchLink + "?c=" + bookName) #获得渲染后的页面
		response = driver.page_source
		driver.close()

		soup = BeautifulSoup(response, "html.parser")
		for jianlou_book in soup.find_all(id="jianlou_book"):
			img120 = jianlou_book.find(class_="img120")
			bookImageLink = img120["src"] #图书图片链接
			bookName = img120["alt"] #图书名称
			book_right_line = jianlou_book.find_all(class_="book_right_line")
			bookDetailLink = book_right_line[0].contents[0]["href"]
			bookISBN = book_right_line[2].find(class_="right").string[-13:] #图书ISBN
			bookPrice = book_right_line[3].find(class_="xianjia").string #图书价格

			d = {
			"promotionBookName": bookName, 
			"promotionBookISBN": bookISBN,
			"promotionBookImageLink": bookImageLink,
			"promotionBookPrice": bookPrice, 
			"promotionBookDetailLink": bookDetailLink}
			searchRerult.append(d)
		return json.dumps(searchRerult, ensure_ascii=False, encoding="utf-8")
	except urllib2.URLError, e:
		print e.reason


def search_promotion_detail_find(promotionBookDetailLink): #活动图书搜索，图书价格信息
	home = "http://www.queshu.com"
	searchRerult = []
	try:
		response = urllib2.urlopen(urllib2.Request(promotionBookDetailLink))
		soup = BeautifulSoup(response, "html.parser")

		book_info = soup.find(class_="book_info")
		bookISBN = book_info.find(text=re.compile(r"\d{13}")) #图书ISBN
		for price_item in soup.find_all(class_="price_item"): #图书价格列表
			book_price = price_item.find(class_="book_price_price")
			if not book_price: #可能为空
				continue

			book_site = price_item.find(class_="book_site")
			bookLink = home + book_site.contents[0]["href"]
			bookSaler = home + book_site.contents[0].contents[0]["src"] #电商图像
			# bookSaler = bookSaler[bookSaler.rfind(r"/") + 1:] 
			bookCurrentPrice = book_price.contents[0]
			if repr(bookCurrentPrice)[0] != 'u': #无规则数据
				continue
			bookCurrentPrice = bookCurrentPrice + book_price.contents[1].string

			d = {
			"bookISBN": bookISBN, 
			"bookSaler": bookSaler, 
			"bookCurrentPrice": bookCurrentPrice, 
			"bookLink": bookLink}
			searchRerult.append(d)
		return json.dumps(searchRerult, ensure_ascii=False, encoding="utf-8")
	except urllib2.URLError, e:
		print e.reason


def sale_list_find(): #活动图书列表
	global sale_list_link_old
	global sale_list_link_new
	home = "http://www.queshu.com"
	try:
		sale_list_link_diff = set(sale_list_link_old) - set(sale_list_link_new) #从活动列表及活动图书中删除旧记录
		for item in set(sale_list_link_diff):
			result = Promotion.objects.filter(promotionID=item) #FIX 改成外键约束
			result.delete()
			result = PromotionBookList.objects.filter(promotionID=item)
			result.delete()
			result = BookPriceList.objects.filter(promotionID=item)
			result.delete()

		sale_list_link_diff = set(sale_list_link_new) - set(sale_list_link_old) #添加新活动到列表
		for item in set(sale_list_link_diff):
			promotionID = item
			sale_list_link = sale_list_link_new[item] #活动图书列表页

			response = urllib2.urlopen(urllib2.Request(sale_list_link))
			soup = BeautifulSoup(response, "html.parser")
			for jianlou_book in soup.find_all(id="jianlou_book"):
				img120 = jianlou_book.find(class_="img120")
				bookImageLink = img120["src"] #图书图片链接
				bookName = img120["alt"] #图书名称
				book_right_line = jianlou_book.find_all(class_="book_right_line")
				bookDetailLink = home + book_right_line[0].contents[0]["href"] #图书详情页链接
				bookPrice = book_right_line[3].find(class_="xianjia").string #图书价格
				
				response = urllib2.urlopen(urllib2.Request(bookDetailLink))
				soup = BeautifulSoup(response, "html.parser")
				book_info = soup.find(class_="book_info")
				bookISBN = book_info.find(text=re.compile(r"\d{13}")) #图书ISBN
				for price_item in soup.find_all(class_="price_item"): #图书价格列表
					book_price = price_item.find(class_="book_price_price")
					if not book_price: #可能为空
						continue

					book_site = price_item.find(class_="book_site")
					bookLink = home + book_site.contents[0]["href"]
					bookSaler = home + book_site.contents[0].contents[0]["src"]
					bookCurrentPrice = book_price.contents[0]
					if repr(bookCurrentPrice)[0] != 'u': #无规则数据
						continue
					bookCurrentPrice = bookCurrentPrice + book_price.contents[1].string

					result = BookPriceList(
						bookISBN         = bookISBN,
						bookSaler        = bookSaler,
						bookCurrentPrice = bookCurrentPrice,
						bookLink         = bookLink)
					result.save()

				result = PromotionBookList(
						promotionID            = promotionID,
						promotionBookISBN      = bookISBN,
						promotionBookName      = bookName,
						promotionBookImageLink = bookImageLink,
						promotionBookPrice     = bookPrice)
				result.save()
		sale_list_link_old = sale_list_link_new
		sale_list_link_new = {}
	except urllib2.URLError, e:
		print e.reason


def news_sale_title_find(): #活动列表
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

				if promotionDeadline: #活动结束时间可能为空
					promotionDeadline = promotionDeadline.encode('utf-8')
				promotionID=promotionLink[-5:]
				promotionSearchLink = ""
				font_13_bold = news_sale_detail.find(href=re.compile("sale_list"))  #参加活动图书列表
				if font_13_bold:
					promotionSearchLink = home[:-6] + font_13_bold["href"]
					sale_list_link_new[promotionID] = promotionSearchLink

				result = Promotion(
					promotionID         = promotionID.encode('utf-8'),
					promotionCompany    = promotionCompany.encode('utf-8'), 
					promotionName       = promotionName.encode('utf-8'), 
					promotionDeadline   = promotionDeadline, 
					promotionLink       = promotionLink.encode('utf-8'),
					promotionSearchLink = promotionSearchLink)
				result.save()
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