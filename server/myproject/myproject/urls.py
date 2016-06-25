from myapp import views
from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    url(r'^admin/', include(admin.site.urls)),
    url(r'^user/login/', views.userLogin),
    url(r'^news/list/', views.promotionList),
    url(r'^promotion/list/', views.promotionList),
    url(r'^user/register/', views.userRegister),
    url(r'^promotion/detail/', views.promotionDetail),
    url(r'^search/promotion/', views.searchPromotion),
    url(r'^search/home/', views.searchHome),
    url(r'^favorite/category/', views.favoriteCategory),
    url(r'^favorite/book/', views.favoriteBook),
)

'''
http://localhost:8000/user/register/?school=uestc&name=shuaihan&studentNo=201421010517&passwd=admin&gender=1&phone=15682017891&email=466629332%40qq.com
http://localhost:8000/user/login/?passwd=admin&name=shuaihan
https://api.douban.com/v2/book/isbn/:9787020042494
'''