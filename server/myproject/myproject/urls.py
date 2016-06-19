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
    url(r'^news/$', views.news),
    url(r'^sale/$', views.sale),
)
