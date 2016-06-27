from django.contrib import admin
# from django.contrib.auth.models import User

from YSGApp.models import User
# Register your models here.

# Re-register UserAdmin
admin.site.register(User)
