from django.db import models

class User(models.Model):
	name = models.CharField(max_length=30, primary_key=True)
	passwd = models.CharField(max_length=14)
	phone = models.CharField(max_length=11)
	school = models.CharField(max_length=50)
	email = models.EmailField()
	studentNo = models.CharField(max_length=20)
	gender = models.BooleanField()

class News(models.Model):
	name = models.CharField(max_length=100)
	link = models.CharField(max_length=100)
	start = models.CharField(max_length=50)
	end = models.CharField(max_length=50)

class Sale(models.Model):
	company = models.CharField(max_length=50)
	name = models.CharField(max_length=100)
	end = models.CharField(max_length=50)
	link = models.CharField(max_length=100)
	