"""
author: 이원영
Description: 
Date: 2024.09.25.
Usage: 맛집 Create(Insert)
"""
import pymysql, os
from fastapi import APIRouter, FastAPI, File, UploadFile
readrouter = APIRouter()

UPLOAD_FOLDER = 'uploads'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)


def connect():
    conn = pymysql.connect(
        host="192.168.50.147",
        user="root",
        password="qwer1234",
        db="musteat",
        charset="utf8"
    )
    return conn

@readrouter.get("/")
async def select():
    conn = connect()
    curs = conn.cursor()
    try:
        sql = 'select seq, category_id,user_seq,name,latitude,longitude,image,phone,represent,memo,favorite from restaurant'
        curs.execute(sql)
        rows= curs.fetchall()
        conn.close()
        print(rows)
        return{'results': rows}
    except Exception as e:
        conn.close()
        print("Error:", e)
        return{"results" : "Error"}

@readrouter.get("/category")
async def select():
    conn = connect()
    curs = conn.cursor()
    try:
        sql = 'select * from category'
        curs.execute(sql)
        rows= curs.fetchall()
        conn.close()
        print(rows)
        return{'results': rows}
    except Exception as e:
        conn.close()
        print("Error:", e)
        return{"results" : "Error"}