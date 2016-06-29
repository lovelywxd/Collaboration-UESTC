#coding=utf-8

from django.db import models

class User(models.Model):
	username  = models.CharField(max_length=30, primary_key=True)
	password  = models.CharField(max_length=14)
	phone     = models.CharField(max_length=11, unique=True)
	school    = models.CharField(max_length=50, default='UESTC')
	email     = models.EmailField(unique=True)
	studentNo = models.CharField(max_length=20)
	gender    = models.BooleanField()

class UserFavourite(models.Model):
	userName = models.CharField(max_length=30)
	bookName = models.CharField(max_length=100)
	ISBN     = models.CharField(max_length=100)

class Promotion(models.Model):
	promotionID         = models.CharField(max_length=100, primary_key=True)
	promotionCompany    = models.CharField(max_length=100)
	promotionName       = models.CharField(max_length=100)
	promotionDeadline   = models.CharField(max_length=50, null=True)
	promotionLink       = models.URLField()
	promotionSearchLink = models.URLField()

class PromotionBookList(models.Model):
	promotionID            = models.CharField(max_length=100)
	promotionBookName      = models.CharField(max_length=100)
	promotionBookImageLink = models.URLField()
	promotionBookISBN      = models.CharField(max_length=20)
	promotionBookPrice     = models.CharField(max_length=10)

class BookPriceList(models.Model):
	bookISBN         = models.CharField(max_length=20)
	bookSaler        = models.CharField(max_length=100)
	bookCurrentPrice = models.CharField(max_length=10)
	bookLink         = models.URLField() #电商图书直达链接