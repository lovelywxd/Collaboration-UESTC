# coding=utf-8
from myapp import views
from django.conf.urls import patterns, include, url

from django.contrib import admin

admin.autodiscover()

urlpatterns = patterns('',
                       url(r'^admin/', include(admin.site.urls)),
                       url(r'^user/login/', views.user_login),
                       url(r'^user/register/', views.user_register),
                       url(r'^user/logout/', views.user_logout),
                       url(r'^promotion/list/', views.promotion_list),
                       url(r'^promotion/detail/', views.promotion_detail),
                       url(r'^search/promotion/list/', views.search_promotion_list),
                       url(r'^search/promotion/detail/', views.search_promotion_detail),
                       url(r'^search/home/list/', views.search_home_list),
                       url(r'^search/home/detail/', views.search_home_detail),
                       url(r'^book/price/list/', views.get_price_list),
                       url(r'^favourite/add/', views.add_favourite),
                       url(r'^favourite/remove/', views.delete_favourite),
                       url(r'^favourite/list/', views.get_favourite),
                       url(r'^order/add/', views.add_shopping_list),
                       url(r'^order/list/', views.get_shopping_list),
                       url(r'^order/remove/', views.delete_shopping_list),
                       url(r'^order/modify/', views.update_shopping_list),
                       url(r'^user/$', views.get_all_user),
                       )


'''
主页搜索
http://115.159.219.141:8000/search/home/list/?bookName=%E5%8E%86%E5%8F%B2
主页搜索，图书详情
http://115.159.219.141:8000/search/home/detail/?bookSubject=https://book.douban.com/subject/5333562/
活动搜索
http://115.159.219.141:8000/search/promotion/list/?bookName=%E8%8B%B1%E6%96%87&promotionID=4100/
活动搜索，图书详情
http://localhost:8000/search/promotion/detail/?promotionBookDetailLink=http://www.queshu.com/book/34034144/

'''