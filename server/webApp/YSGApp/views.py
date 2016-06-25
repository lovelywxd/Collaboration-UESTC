from django.http import HttpResponse
from django.http import JsonResponse
from YSGApp.models import User


# Create your views here.


# POST /user/register
def register(request):
    pass


# POST /user/authenticate
def login(request):
    pass


# POST /user/logout
def logout(request):
    pass


# GET /acts
def acts(request):
    pass


# GET /acts/{act_id}
def acts_id(request):
    pass


# GET /acts/{book_name}
def acts_book_search(request):
    pass


# GET /{acts_id}/{book_name}
def acts_id_book_search(request):
    pass


# POST /user/favourite/add
def add_favourite(request):
    pass


# GET /user/favourite
def get_favourite(request):
    pass


# post /user/favourite/delete
def delete_favourite(request):
    pass

