"""
author: 이원영
Description: 
Fixed: 2024.09.26.
Usage: 맛집, 카테고리 Read(select)
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
        result = [{'seq' : row[0], 'category_id' : row[1], 'user_seq' : row[2], 'name' : row[3], 'latitude' : row[4], 'longitude': row[5], 'image': row[6], 'phone': row[7], 'represent': row[8], 'memo': row[9], 'favorite': row[10]} for row in rows]
        print(f"맛집 검색 \n{result}")
        return{'results': result}
    except Exception as e:
        conn.close()
        print("Error:", e)
        return{"results" : "Error"}

@readrouter.get("/bycategory")
async def getbyCategory(keyword : str):
    conn = connect()
    curs = conn.cursor()
    try:
        sql = """
                select 
                    seq, category_id, user_seq, name, latitude, longitude, image, phone, represent, memo, favorite 
                from 
                    restaurant
                where 
                    category_id like %s
              """
        curs.execute(sql, (keyword))
        rows= curs.fetchall()
        result = [{'seq' : row[0], 'category_id' : row[1], 'user_seq' : row[2], 'name' : row[3], 'latitude' : row[4], 'longitude': row[5], 'image': row[6], 'phone': row[7], 'represent': row[8], 'memo': row[9], 'favorite': row[10]} for row in rows]
        print(f"카테고리별 검색 \n{result}")
        conn.close()
        print(rows)
        return{'results': result}
    except Exception as e:
        conn.close()
        print("Error:", e)
        return{"results" : "Error"}


@readrouter.get("/bykeyword")
async def getbyCategory(keyword : str):
    conn = connect()
    curs = conn.cursor()
    try:
        sql = """
                select 
                    seq, category_id, user_seq, name, latitude, longitude, image, phone, represent, memo, favorite 
                from 
                    restaurant
                where 
                    category_id like %s or name like %s or represent like %s or memo like %s
              """
        curs.execute(sql, (keyword, keyword, keyword, keyword))
        rows= curs.fetchall()
        result = [{'seq' : row[0], 'category_id' : row[1], 'user_seq' : row[2], 'name' : row[3], 'latitude' : row[4], 'longitude': row[5], 'image': row[6], 'phone': row[7], 'represent': row[8], 'memo': row[9], 'favorite': row[10]} for row in rows]
        print(f"키워드로 검색 \n{result}")
        conn.close()
        return{'results': result}
    except Exception as e:
        conn.close()
        print("Error:", e)
        return{"results" : "Error"}


@readrouter.get("/favorite")
async def getFavoriteRestaurant(favorite : str):
    conn = connect()
    curs = conn.cursor()
    try:
        sql = """
                select 
                    seq, category_id, user_seq, name, latitude, longitude, image, phone, represent, memo, favorite 
                from 
                    restaurant
                where 
                    favorite=%s
              """
        curs.execute(sql,(favorite))
        rows= curs.fetchall()
        result = [{'seq' : row[0], 'category_id' : row[1], 'user_seq' : row[2], 'name' : row[3], 'latitude' : row[4], 'longitude': row[5], 'image': row[6], 'phone': row[7], 'represent': row[8], 'memo': row[9], 'favorite': row[10]} for row in rows]
        print(f"즐겨찾기한 맛집 \n{result}")
        conn.close()
        return{'results': result}
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
        result = [{'id': row} for row in rows]
        print(result)
        return{'results': result}
    except Exception as e:
        conn.close()
        print("Error:", e)
        return{"results" : "Error"}