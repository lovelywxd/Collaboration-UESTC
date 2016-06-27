from django.db import models

class User(models.Model):
	name      = models.CharField(max_length=30, primary_key=True)
	passwd    = models.CharField(max_length=14)
	phone     = models.CharField(max_length=11)
	school    = models.CharField(max_length=50)
	studentNo = models.CharField(max_length=20)
	email     = models.EmailField()
	gender    = models.BooleanField()

class Promotion(models.Model):
	promotionID       = models.CharField(max_length=100, primary_key=True)
	promotionCompany  = models.CharField(max_length=100)
	promotionName     = models.CharField(max_length=100)
	promotionDeadline = models.CharField(max_length=50, null=True)
	promotionLink     = models.URLField()

class PromotionBookList(models.Model):
	promotionID               = models.CharField(max_length=100, primary_key=True)
	promotionBookISBN         = models.CharField(max_length=20)
	promotionBookPrice        = models.CharField(max_length=10)
	promotionBookCurrentPrice = models.CharField(max_length=10)
	promotionBookSearchLink   = models.URLField()


class BookPriceList(models.Model):
	bookISBN  = models.CharField(max_length=20, primary_key=True)
	bookSaler = models.CharField(max_length=100)
	bookCurrentPrice = models.CharField(max_length=10)