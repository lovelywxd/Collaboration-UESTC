from myapp import views
from django.conf.urls import patterns, include, url

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'myproject.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^admin/', include(admin.site.urls)),
    url(r'^login/', views.login),
    url(r'^register/', views.register),
<<<<<<< HEAD
    url(r'^news/$', views.news),
    url(r'^sale/$', views.sale),
=======
>>>>>>> 4e309638c24d78a3b993fd2530c56c5e4392e56d
)
