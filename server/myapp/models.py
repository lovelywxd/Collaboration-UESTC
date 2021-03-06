# -*- coding: UTF-8 -*-
from django.db import models


class DataDict(object):
    def to_dict(self):
        fields = []
        for field in self._meta.fields:
            fields.append(field.name)
        object_dict = {}
        for attr in fields:
            object_dict[attr] = getattr(self, attr)
        return object_dict


class User(models.Model, DataDict):
    userName = models.CharField(max_length=30, primary_key=True)
    password = models.CharField(max_length=60)
    phone = models.CharField(max_length=14, unique=True)
    school = models.CharField(max_length=50, default='UESTC')
    email = models.EmailField(unique=True)
    studentNo = models.CharField(max_length=20, null=True)
    gender = models.BooleanField()
    # image = models.ImageField(upload_to='user_image', null=True)

class Meta:
    db_table = 'User'

class UserFavourite(models.Model, DataDict):
    userName = models.CharField(max_length=30)
    bookISBN = models.CharField(max_length=100)
    bookName = models.CharField(max_length=100, null=True)
    # 新增
    bookImageLink = models.URLField(null=True)


class Promotion(models.Model, DataDict):
    promotionID = models.CharField(max_length=100, primary_key=True)
    promotionCompany = models.CharField(max_length=100)
    promotionName = models.CharField(max_length=100)
    promotionDeadline = models.CharField(max_length=50, null=True)
    promotionLink = models.URLField()
    promotionSearchLink = models.URLField()


class PromotionBookList(models.Model, DataDict):
    promotionID = models.CharField(max_length=100)
    promotionBookISBN = models.CharField(max_length=20)
    promotionBookPrice = models.CharField(max_length=10)
    promotionBookImageLink = models.URLField()
    promotionBookName = models.CharField(max_length=100)


class BookPriceList(models.Model, DataDict):
    # bookISBN = models.CharField(max_length=20, primary_key=True)
    bookISBN = models.CharField(max_length=20)
    bookSaler = models.CharField(max_length=100)
    bookCurrentPrice = models.CharField(max_length=10)
    bookLink = models.URLField()  # 电商图书直达链接


class UserOrder(models.Model, DataDict):
    userName = models.CharField(max_length=30)
    promotionID = models.CharField(max_length=100)
    promotionBookISBN = models.CharField(max_length=20)
    bookAmount = models.IntegerField(default=1)
    
