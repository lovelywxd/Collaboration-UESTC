from django.db import models

class User(models.Model):
	name      = models.CharField(max_length=30, primary_key=True)
	passwd    = models.CharField(max_length=14)
	phone     = models.CharField(max_length=11)
	school    = models.CharField(max_length=50)
	email     = models.EmailField()
	studentNo = models.CharField(max_length=20)
	gender    = models.BooleanField()

class News(models.Model):
	newsName      = models.CharField(max_length=100)
	newsLink      = models.CharField(max_length=100)
	newsStarttime = models.CharField(max_length=50)
	newsDeadline  = models.CharField(max_length=50)

class Promotion(models.Model):
	promotionID       = models.CharField(max_length=100, primary_key=True)
	promotionCompany  = models.CharField(max_length=100)
	promotionName     = models.CharField(max_length=100)
	promotionLink     = models.URLField()
	promotionDeadline = models.CharField(max_length=50, null=True)

class PromotionBookList(models.Model):
	promotionID         = models.CharField(max_length=100, primary_key=True)
	promotionSearchLink = models.URLField()
	promotionBookISBN   = models.CharField(max_length=20)

class BookInformation(models.Model):
	bookISBN        = models.CharField(max_length=20, primary_key=True)
	bookName        = models.CharField(max_length=100)
	bookAuthor      = models.CharField(max_length=50)
	bookPublisher   = models.CharField(max_length=50)
	bookPublishDate = models.CharField(max_length=20)
	bookPrice       = models.CharField(max_length=10)
	doubanLink      = models.URLField()
	doubanImage     = models.URLField()
	doubanRating    = models.FloatField()
	doubanSummary   = models.TextField()

class BookPrice(models.Model)
	bookISBN  = models.CharField(max_length=20, primary_key=True)
	bookSaler = models.CharField(max_length=100)
	bookPrice = models.CharField(max_length=10)