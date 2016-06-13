from django.db import models

class User(models.Model):
	name = models.CharField(max_length=30, primary_key=True)
	passwd = models.CharField(max_length=14)
	phone = models.CharField(max_length=11)
	school = models.CharField(max_length=50)
	email = models.EmailField()
	studentNo = models.CharField(max_length=20)
	gender = models.BooleanField()