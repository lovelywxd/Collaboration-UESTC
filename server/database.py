#coding=utf-8
import MySQLdb, json

def user_info_create(): #创建用户信息表
    db = MySQLdb.connect("localhost", "root", "admin", "app")
    cursor = db.cursor()
    sql = "drop table if exists user_info"
    cursor.execute(sql)
    sql = """create table user_info(
            username char(14),
            password char(14),
            phone char(11),
            school char(50))
            character set = utf8;"""
    cursor.execute(sql)
    db.close()

def user_info_insert(username, password, phone, school): #更新用户信息，如果用户已经存在，则返回0
    db = MySQLdb.connect("localhost", "root", "admin", "app")
    cursor = db.cursor()
    sql = 'select * from user_info where username="{0}"'.format(username)
    cursor.execute(sql)
    result = cursor.fetchall()
    if result:
        return 0
    try:
        sql = 'insert into user_info values("{0}", "{1}", {2}, "{3}");'.format(username, password, phone, school)
        print sql
        cursor.execute(sql)
        db.commit()
    except:
        db.rollback()
    db.close()

def user_info_select(username): #查询用户信息，返回结果为json格式，中文为utf-8编码
    db = MySQLdb.connect("localhost", "root", "admin", "app")
    cursor = db.cursor()
    sql = 'select * from user_info where username="{0}"'.format(username)
    cursor.execute(sql)
    results = cursor.fetchone()
    db.close()
    username = results[0]
    password = results[1]
    phone = results[2]
    school = results[3]
    result = json.dumps({"username":username, "password":password, "phone":phone, "school":school}, ensure_ascii=False)
    return result

def news_info_create():
    db = MySQLdb.connect("localhost", "root", "admin", "app")
    cursor = db.cursor()
    sql = "drop table if exists book_info"
    cursor.execute(sql)
    sql = """create table news_info(
            id int auto_increment not null primary key,
            name varchar(14),
            link varchar(20))"""
    cursor.execute(sql)
    db.close()

def news_info_update():
    pass