"""
author: 이원영
Description: 
Fixed: 2024.09.26.
Usage: 맛집 Create(Insert)
"""
import pymysql, os
from fastapi import APIRouter
router = APIRouter()

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

@router.get("/restaurant")
async def insertRestaurant(categoryId: str=None, userSeq: str=None, name:str=None, latitude:str=None, longitude: str=None, image:str=None, phone:str=None, represent:str=None, memo:str=None, favorite:str=None):
    conn = connect()
    curs = conn.cursor()
    try:
        sql = "insert into restaurant(category_id,user_seq,name,latitude,longitude,image,phone,represent,memo,favorite) values(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
        curs.execute(sql,(categoryId,userSeq,name,latitude,longitude,image,phone,represent,memo,favorite))
        conn.commit()
        conn.close()
        return {'result':'OK'}
    except Exception as e:
        conn.close()
        print("Error:", e)
        return{"results" : "Error"}


@router.get("/category")
async def insertCategory(id: str):
    conn = connect()
    curs = conn.cursor()
    try:
        sql = "insert into category(id) values(%s)"
        curs.execute(sql,(id))
        conn.commit()
        conn.close()
        return {'result':'OK'}
    except Exception as e:
        conn.close()
        print("Error:", e)
        return{"results" : "Error"}
