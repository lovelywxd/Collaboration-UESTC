#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
database: User,
consider：these three database. how to store data, and the relationship between these three db.
"""

import time
import uuid

from orm import Model, StringField, BooleanField, FloatField, TextField


class User(Model):
    __table__ = "users"
    studentNo = StringField(ddl="varchar(50)")
    email = StringField(ddl="varchar(50)")
    passwd = StringField(ddl="varchar(50)")
    gender = BooleanField()
    name = StringField(primarykey=True, ddl="varchar(50)")
    # image = StringField(ddl="varchar(500)")
    phone = StringField(ddl="varchar(14)")
    school = StringField(ddl="varchar(50)", default='UESTC')