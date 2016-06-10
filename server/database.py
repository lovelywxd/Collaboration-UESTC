#coding=utf-8
import MySQLdb

def user_info_create():
    db = MySQLdb.connect("localhost", "root", "admin", "app")
    cursor = db.cursor()
    sql = "drop table if exists user_info"
    cursor.execute(sql)
    sql = """create table user_info(
            name varchar(10),
            password varchar(14),
            phone varchar(11),
            school varchar(20))"""
    cursor.execute(sql)
    db.close()

def user_info_update(name, password, phone, school):
    db = MySQLdb.connect("localhost", "root", "admin", "app")
    cursor = db.cursor()

def book_info_create():
    pass

def book_info_update():
    pass