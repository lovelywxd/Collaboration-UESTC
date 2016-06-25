from django.db import models
# Create your models here.


class User(models.Model):
    name = models.CharField(max_length=30, primary_key=True)
    passwd = models.CharField(max_length=14)
    phone = models.CharField(max_length=11)
    school = models.CharField(max_length=50)
    email = models.EmailField(unique=True)
    studentNo = models.CharField(max_length=20)
    gender = models.BooleanField()

    def __str__(self):
        return self.User_text


class Promotion(models.Model):
    # PB: Personal Buy. GB:Group Buy
    promotionID = models.CharField(max_length=100, primary_key=True)
    promotionName = models.CharField(max_length=100)
    promotionLink = models.URLField()

    def __str__(self):
        return self.Promotion_text


class BookInfor(models.Model):
    ISBN = models.CharField(max_length=100, primary_key=True)
    bookName = models.CharField(max_length=100)
    author = models.CharField(max_length=50)
    imageLink = models.URLField()
    doubanScore = models.FloatField()
    doubanLink = models.URLField()
    salesLink = models.URLField()
    description = models.TextField()
    originalPrice = models.FloatField()

    def __str__(self):
        return self.name


class BookPriceList(models.Model):
    priceListID = models.AutoField(primary_key=True)
    ISBN = models.CharField(max_length=100, unique=True)
    businessID = models.CharField(max_length=100, unique=True)
    currentPrice = models.FloatField()
    discount = models.FloatField()
    promotionID = models.CharField(max_length=100, default=0)

    def __str__(self):
        return self.name


# class UserFavourite(models.Model):
# 	userName = models.CharField(max_length=30, primary_key=True)
# 	category = models.CharField(max_length=100,default=null)
# 	bookList = models.CharField(max_length=100)
class UserFavourite(models.Model):
    userName = models.CharField(max_length=30, primary_key=True)
    category = models.CharField(max_length=50, default=0)
    ISBN = models.CharField(max_length=100)

    def __str__(self):
        return self.name
